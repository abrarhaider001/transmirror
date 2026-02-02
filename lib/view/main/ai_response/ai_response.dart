import 'package:flutter/material.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class AiResponsePage extends StatelessWidget {
  const AiResponsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: MyColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            LayoutPagesAppBar(title: 'AI Response', showTrailing: false),
            Expanded(child: Center(child: Text('AI Response Content'))),
          ],
        ),
      ),
    );
  }
}
