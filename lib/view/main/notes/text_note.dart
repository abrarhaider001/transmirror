import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

class TextNotePage extends StatelessWidget {
  const TextNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.softGrey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.createNote),
        backgroundColor: MyColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LayoutPagesAppBar(
              title: 'Text Note',
              showTrailing: true,
              trailingWidget: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Iconsax.folder_add, color: MyColors.primary, size: 18,),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  _NoteCard(
                    day: 'MON',
                    date: '24',
                    title: 'Edworking Tasks',
                    time: '12:26',
                    content: 'Create logos for inquiries in the chat lists and for the projects',
                  ),
                  SizedBox(height: 16),
                  _NoteCard(
                    day: 'TUE',
                    date: '25',
                    title: 'Premium Options Chanes',
                    time: '14:49',
                    content: 'Marketing offers and instruments that should get better attention to the markers',
                  ),
                  SizedBox(height: 16),
                  _NoteCard(
                    day: 'WED',
                    date: '26',
                    title: 'Opportunity For Me',
                    time: '15:34',
                    content: 'Once this all going to happen, it\'s going to be just wonderful. Until then, trying best if luck',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String day;
  final String date;
  final String title;
  final String time;
  final String content;

  const _NoteCard({
    required this.day,
    required this.date,
    required this.title,
    required this.time,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: MyColors.softGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      day,
                      style: MyTextTheme.lightTextTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      date,
                      style: MyTextTheme.lightTextTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: MyTextTheme.lightTextTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: MyTextTheme.lightTextTheme.labelSmall?.copyWith(
                        color: MyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: MyColors.textSecondary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: MyTextTheme.lightTextTheme.bodyMedium?.copyWith(
              color: MyColors.textSecondary,
              height: 1.5,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
