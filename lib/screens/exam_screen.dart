import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/exam_controller.dart';
import '../theme.dart';
import '../responsive.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ExamController());

    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        final confirm = await _showExitDialog(context);
        if (confirm == true) Get.back();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.exam),
                  SizedBox(height: 16),
                  Text('កំពុងរៀបចំការប្រឡង...'),
                ],
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                ResponsiveCenter(child: _ExamHeader(ctrl: ctrl)),
                ResponsiveCenter(child: _ProgressBar(ctrl: ctrl)),
                Expanded(
                  child: ResponsiveCenterExpand(child: _QuestionBody(ctrl: ctrl)),
                ),
                ResponsiveCenter(child: _NavigationBar(ctrl: ctrl)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('ចាកចេញពីការប្រឡង?', style: GoogleFonts.notoSansKhmer(fontWeight: FontWeight.w700)),
        content: Text('ប្រសិនបើអ្នកចាកចេញ លទ្ធផលនឹងត្រូវបានលុប។', style: GoogleFonts.notoSansKhmer()),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('នៅតែបន្ត', style: GoogleFonts.notoSansKhmer(color: AppColors.exam)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('ចាកចេញ', style: GoogleFonts.notoSansKhmer(color: AppColors.emergency)),
          ),
        ],
      ),
    );
  }
}

class _ExamHeader extends StatelessWidget {
  final ExamController ctrl;
  const _ExamHeader({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 22),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('ចាកចេញ?', style: GoogleFonts.notoSansKhmer(fontWeight: FontWeight.w700)),
                  content: Text('ប្រសិនបើអ្នកចាកចេញ លទ្ធផលនឹងត្រូវបានលុប។', style: GoogleFonts.notoSansKhmer()),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: Text('នៅតែបន្ត', style: GoogleFonts.notoSansKhmer(color: AppColors.exam)),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: Text('ចាកចេញ', style: GoogleFonts.notoSansKhmer(color: AppColors.emergency)),
                    ),
                  ],
                ),
              );
              if (confirm == true) Get.back();
            },
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'ការប្រឡង',
              style: GoogleFonts.notoSansKhmer(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Timer
          Obx(() {
            final seconds = ctrl.timeLeft.value;
            final isUrgent = seconds < 300; // < 5 min
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isUrgent ? AppColors.emergency.withOpacity(0.1) : AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isUrgent ? AppColors.emergency.withOpacity(0.4) : AppColors.divider,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: isUrgent ? AppColors.emergency : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ctrl.formattedTime,
                    style: GoogleFonts.notoSansKhmer(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isUrgent ? AppColors.emergency : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(width: 8),
          // Answered count
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.exam.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${ctrl.answeredCount}/45',
              style: GoogleFonts.notoSansKhmer(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.exam,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final ExamController ctrl;
  const _ProgressBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final progress = (ctrl.currentIndex.value + 1) / ctrl.examQuestions.length;
      return Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.exam),
            minHeight: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'សំណួរ ${ctrl.currentIndex.value + 1} / ${ctrl.examQuestions.length}',
                  style: GoogleFonts.notoSansKhmer(fontSize: 12, color: AppColors.textSecondary),
                ),
                _SectionBadge(index: ctrl.currentIndex.value),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _SectionBadge extends StatelessWidget {
  final int index;
  const _SectionBadge({required this.index});

  String _sectionLabel() {
    if (index < 15) return 'ច្បាប់ទូទៅ';
    if (index < 25) return 'សញ្ញាចរាចរ';
    if (index < 30) return 'អាទិភាព ⚡';
    if (index < 35) return 'ច្បាប់ទូទៅ';
    if (index < 40) return 'បច្ចេកទេស';
    return 'អាសន្ន';
  }

  Color _sectionColor() {
    if (index < 15) return AppColors.general;
    if (index < 25) return AppColors.sign;
    if (index < 30) return AppColors.priority;
    if (index < 35) return AppColors.general;
    if (index < 40) return AppColors.technique;
    return AppColors.emergency;
  }

  @override
  Widget build(BuildContext context) {
    final color = _sectionColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        _sectionLabel(),
        style: GoogleFonts.notoSansKhmer(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _QuestionBody extends StatelessWidget {
  final ExamController ctrl;
  const _QuestionBody({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final eq = ctrl.current;
      final q = eq.question;

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: q.hasImage
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            q.imagePath,
                            height: 180,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.divider,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'តើសញ្ញានេះមានន័យអ្វី?',
                          style: GoogleFonts.notoSansKhmer(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Text(
                      q.question,
                      style: GoogleFonts.notoSansKhmer(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            // Options
            ...List.generate(3, (i) => _OptionTile(
              ctrl: ctrl,
              index: i,
              eq: eq,
            )),
          ],
        ),
      );
    });
  }
}

class _OptionTile extends StatelessWidget {
  final ExamController ctrl;
  final int index;
  final ExamQuestion eq;
  const _OptionTile({required this.ctrl, required this.index, required this.eq});

  @override
  Widget build(BuildContext context) {
    final options = eq.question.options;
    final isSelected = eq.selectedAnswer == index;
    final labels = ['ក', 'ខ', 'គ'];

    return GestureDetector(
      onTap: () => ctrl.selectAnswer(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.selectedBg : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.selectedBorder : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.selectedBorder : AppColors.cardBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  labels[index],
                  style: GoogleFonts.notoSansKhmer(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                options[index],
                style: GoogleFonts.notoSansKhmer(
                  fontSize: 14,
                  color: isSelected ? AppColors.textPrimary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.selectedBorder, size: 20),
          ],
        ),
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  final ExamController ctrl;
  const _NavigationBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Obx(() => Row(
        children: [
          // Back button
          if (!ctrl.isFirstQuestion)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: ctrl.previous,
                icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                label: Text('ត្រឡប់', style: GoogleFonts.notoSansKhmer(fontSize: 14)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.divider),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          if (!ctrl.isFirstQuestion) const SizedBox(width: 12),
          // Next / Finish button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: ctrl.current.selectedAnswer != null ? ctrl.next : null,
              icon: Icon(
                ctrl.isLastQuestion ? Icons.flag : Icons.arrow_forward_ios,
                size: 16,
              ),
              label: Text(
                ctrl.isLastQuestion ? 'បញ្ចប់ការប្រឡង' : 'បន្ទាប់',
                style: GoogleFonts.notoSansKhmer(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ctrl.current.selectedAnswer != null
                    ? (ctrl.isLastQuestion ? AppColors.emergency : AppColors.exam)
                    : AppColors.divider,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
