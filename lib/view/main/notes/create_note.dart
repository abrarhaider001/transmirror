import 'package:flutter/material.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class CreateNotePage extends StatelessWidget {
  const CreateNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            const LayoutPagesAppBar(title: 'Create Note', showTrailing: false),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Start typing...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
