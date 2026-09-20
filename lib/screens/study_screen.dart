import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/study_controller.dart';
import '../models/question.dart';
import '../theme.dart';
import '../responsive.dart';

class StudyScreen extends StatelessWidget {
  final String category;
  const StudyScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudyController(category), tag: category);
    final color = categoryColor(category);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Text(
          categoryLabel(category),
          style: GoogleFonts.notoSansKhmer(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: ResponsiveCenterExpand(
        child: Column(
        children: [
          _SearchBar(controller: controller, color: color),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator(color: color));
              }
              if (controller.filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🔍', style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(
                        'រកមិនឃើញ',
                        style: GoogleFonts.notoSansKhmer(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }
              final pad = Responsive.pagePadding(context);
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(pad, 12, pad, 24),
                itemCount: controller.filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  return _QuestionCard(
                    question: controller.filtered[i],
                    index: i,
                    color: color,
                  );
                },
              );
            }),
          ),
        ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final StudyController controller;
  final Color color;
  const _SearchBar({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                onChanged: controller.search,
                style: GoogleFonts.notoSansKhmer(fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'ស្វែងរកសំណួរ...',
                  hintStyle: GoogleFonts.notoSansKhmer(fontSize: 14, color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.search, size: 20, color: color),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${controller.filtered.length}',
              style: GoogleFonts.notoSansKhmer(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatefulWidget {
  final Question question;
  final int index;
  final Color color;
  const _QuestionCard({required this.question, required this.index, required this.color});

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final options = [q.option0, q.option1, q.option2];

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _expanded ? widget.color.withOpacity(0.4) : AppColors.divider,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index + 1}',
                        style: GoogleFonts.notoSansKhmer(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: q.hasImage
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  q.imagePath,
                                  height: 100,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 80,
                                    color: AppColors.divider,
                                    child: const Center(child: Icon(Icons.image_not_supported)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                q.question,
                                style: GoogleFonts.notoSansKhmer(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            q.question,
                            style: GoogleFonts.notoSansKhmer(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                  ),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              Container(height: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: List.generate(3, (i) {
                    final isCorrect = i == q.answer;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isCorrect ? AppColors.correctBg : AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isCorrect ? AppColors.correctBorder : AppColors.divider,
                          width: isCorrect ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (isCorrect)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.check_circle, color: AppColors.correctBorder, size: 16),
                            ),
                          Expanded(
                            child: Text(
                              options[i],
                              style: GoogleFonts.notoSansKhmer(
                                fontSize: 13,
                                color: isCorrect ? AppColors.correctBorder : AppColors.textPrimary,
                                fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
