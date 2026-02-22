import 'dart:io';

import 'package:docx_file_viewer/docx_file_viewer.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';

class DocumentViewerPage extends StatefulWidget {
  final String filePath;
  final String fileName;

  const DocumentViewerPage({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<DocumentViewerPage> createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  bool _isLoading = true;
  PDFDocument? _pdfDocument;
  late final bool _isPdf;
  late final bool _isDocx;

  @override
  void initState() {
    super.initState();
    final path = widget.filePath.toLowerCase();
    _isPdf = path.endsWith('.pdf');
    _isDocx = path.endsWith('.docx');

    if (_isPdf) {
      _loadPdfDocument();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadPdfDocument() async {
    try {
      final file = File(widget.filePath);
      final document = await PDFDocument.fromFile(file);
      if (!mounted) return;
      setState(() {
        _pdfDocument = document;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildContent() {
    if (_isPdf) {
      if (_isLoading || _pdfDocument == null) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              MyColors.primary,
            ),
          ),
        );
      }

      return PDFViewer(
        document: _pdfDocument!,
        lazyLoad: true,
        scrollDirection: Axis.vertical,
        showNavigation: false,
        showPicker: false,
        showIndicator: false,
        backgroundColor: MyColors.softGrey,
      );
    }

    if (_isDocx) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: DocxView.file(
          File(widget.filePath),
          config: DocxViewConfig(
            enableZoom: false,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            backgroundColor: MyColors.softGrey,
          ),
        ),
      );
    }

    return const Center(
      child: Text(
        'Unsupported file type',
        style: TextStyle(
          fontSize: 14,
          color: MyColors.textSecondary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            LayoutPagesAppBar(
              title: widget.fileName,
              showTrailing: false,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: InteractiveViewer(
                    panEnabled: false,
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
