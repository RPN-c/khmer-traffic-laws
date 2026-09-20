import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/exam_controller.dart';
import '../theme.dart';
import '../responsive.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final bool priorityFailed;
  final int priorityFailedIndex;
  final bool timeout;
  final List<ExamQuestion> examQuestions;
  final int answeredUpTo;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.priorityFailed,
    required this.priorityFailedIndex,
    required this.timeout,
    required this.examQuestions,
    required this.answeredUpTo,
  });

  bool get passed => !priorityFailed && score >= 38;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ResponsiveCenter(child: _buildHeader()),
            Expanded(
              child: SingleChildScrollView(
                child: ResponsiveCenter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(Responsive.pagePadding(context), 0, Responsive.pagePadding(context), 24),
                    child: Column(
                      children: [
                        _buildScoreCard(),
                        const SizedBox(height: 16),
                        if (priorityFailed) _buildPriorityFailBanner(context),
                        if (timeout) _buildTimeoutBanner(),
                        const SizedBox(height: 16),
                        _buildStats(),
                        const SizedBox(height: 20),
                        _buildReviewSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ResponsiveCenter(child: _buildBottomActions(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Text(
            'លទ្ធផលការប្រឡង',
            style: GoogleFonts.notoSansKhmer(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    final color = passed ? AppColors.correctBorder : AppColors.emergency;
    final emoji = passed ? '🎉' : '😔';
    final label = passed ? 'បានជាប់' : 'បានធ្លាក់';
    final labelEn = passed ? 'PASSED' : 'FAILED';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text(label,
              style: GoogleFonts.notoSansKhmer(
                  fontSize: 26, fontWeight: FontWeight.w800, color: color)),
          Text(labelEn,
              style: GoogleFonts.notoSansKhmer(
                  fontSize: 13, color: color.withOpacity(0.7), letterSpacing: 2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$score',
                  style: GoogleFonts.notoSansKhmer(
                      fontSize: 64, fontWeight: FontWeight.w900, color: color, height: 1)),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('/$total',
                    style: GoogleFonts.notoSansKhmer(
                        fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('ពិន្ទុ',
              style: GoogleFonts.notoSansKhmer(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score / total,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text('ត្រូវការ ≥38 ពិន្ទុ ដើម្បីជាប់',
              style: GoogleFonts.notoSansKhmer(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // Banner with a "Jump to question" button
  Widget _buildPriorityFailBanner(BuildContext context) {
    final failedEq = priorityFailedIndex >= 0 ? examQuestions[priorityFailedIndex] : null;
    final qNumber = priorityFailedIndex + 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.priority.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.priority.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.priority.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('⚡', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ធ្លាក់ដោយសារសំណួរអាទិភាព',
                      style: GoogleFonts.notoSansKhmer(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.priority,
                      ),
                    ),
                    Text(
                      'Priority question auto-fail',
                      style: GoogleFonts.notoSansKhmer(
                        fontSize: 11,
                        color: AppColors.priority.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (failedEq != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.priority.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.priority,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Q$qNumber',
                          style: GoogleFonts.notoSansKhmer(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'សំណួរដែលធ្វើអោយធ្លាក់',
                        style: GoogleFonts.notoSansKhmer(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Show image or question text
                  if (failedEq.question.hasImage)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        failedEq.question.imagePath,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, size: 40),
                      ),
                    )
                  else
                    Text(
                      failedEq.question.question,
                      style: GoogleFonts.notoSansKhmer(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 12),
                  // Wrong answer (what they chose)
                  _AnswerRow(
                    label: 'ចម្លើយរបស់អ្នក',
                    text: failedEq.question.options[failedEq.selectedAnswer!],
                    optionLabel: ['ក', 'ខ', 'គ'][failedEq.selectedAnswer!],
                    isCorrect: false,
                  ),
                  const SizedBox(height: 6),
                  // Correct answer
                  _AnswerRow(
                    label: 'ចម្លើយត្រឹមត្រូវ',
                    text: failedEq.question.options[failedEq.question.answer],
                    optionLabel: ['ក', 'ខ', 'គ'][failedEq.question.answer],
                    isCorrect: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Scroll-to button
            GestureDetector(
              onTap: () {
                // Scroll to Q in review section — using a global key is complex,
                // instead we show a snackbar pointing to the question number
                Get.snackbar(
                  '',
                  '',
                  titleText: Text(
                    'សំណួរអាទិភាព Q$qNumber',
                    style: GoogleFonts.notoSansKhmer(fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  messageText: Text(
                    'រកមើលនៅផ្នែក "ពិនិត្យចម្លើយ" ខាងក្រោម — សំណួរទី $qNumber បន្លំ ⚡',
                    style: GoogleFonts.notoSansKhmer(fontSize: 12, color: Colors.white70),
                  ),
                  backgroundColor: AppColors.priority,
                  snackPosition: SnackPosition.BOTTOM,
                  borderRadius: 12,
                  margin: const EdgeInsets.all(12),
                  duration: const Duration(seconds: 3),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.priority.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.priority.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    'មើលនៅផ្នែកពិនិត្យចម្លើយ ↓',
                    style: GoogleFonts.notoSansKhmer(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.priority,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeoutBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.emergency.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.emergency.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('⏱️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ពេលវេលាអស់ — ការប្រឡងត្រូវបានបញ្ចប់ដោយស្វ័យប្រវត្តិ',
              style: GoogleFonts.notoSansKhmer(
                  fontSize: 13, color: AppColors.emergency, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    int correct = 0, wrong = 0, skipped = 0;
    for (int i = 0; i < answeredUpTo; i++) {
      final eq = examQuestions[i];
      if (eq.selectedAnswer == null) {
        skipped++;
      } else if (eq.selectedAnswer == eq.question.answer) {
        correct++;
      } else {
        wrong++;
      }
    }
    final notReached = total - answeredUpTo;

    return Row(
      children: [
        _StatBox('✅', '$correct', 'ត្រូវ', AppColors.correctBorder),
        const SizedBox(width: 8),
        _StatBox('❌', '$wrong', 'ខុស', AppColors.emergency),
        const SizedBox(width: 8),
        if (notReached > 0)
          _StatBox('⏭️', '$notReached', 'មិនដល់', AppColors.textSecondary)
        else
          _StatBox('⬜', '$skipped', 'មិនឆ្លើយ', AppColors.textSecondary),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ពិនិត្យចម្លើយ',
          style: GoogleFonts.notoSansKhmer(
              fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        ...List.generate(answeredUpTo, (i) {
          final eq = examQuestions[i];
          final isCorrect = eq.selectedAnswer == eq.question.answer;
          final isSkipped = eq.selectedAnswer == null;
          final isPriority = eq.question.category == 'priority';
          final isCauseOfFail = i == priorityFailedIndex;

          Color borderColor = AppColors.divider;
          Color bgColor = AppColors.cardBg;
          if (isCauseOfFail) {
            borderColor = AppColors.priority;
            bgColor = AppColors.priority.withOpacity(0.06);
          } else if (!isSkipped && isCorrect) {
            borderColor = AppColors.correctBorder.withOpacity(0.4);
            bgColor = AppColors.correctBg;
          } else if (!isSkipped) {
            borderColor = AppColors.wrongBorder.withOpacity(0.4);
            bgColor = AppColors.wrongBg;
          }

          final options = eq.question.options;
          final labels = ['ក', 'ខ', 'គ'];

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
                width: isCauseOfFail ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Text('Q${i + 1}',
                          style: GoogleFonts.notoSansKhmer(
                              fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    // Priority badge
                    if (isPriority)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.priority.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('⚡ អាទិភាព',
                            style: GoogleFonts.notoSansKhmer(
                                fontSize: 11, color: AppColors.priority, fontWeight: FontWeight.w600)),
                      ),
                    // "Caused fail" badge
                    if (isCauseOfFail) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.priority,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('ហេតុបណ្ដាលឱ្យធ្លាក់',
                            style: GoogleFonts.notoSansKhmer(
                                fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ],
                    const Spacer(),
                    Icon(
                      isSkipped
                          ? Icons.remove_circle_outline
                          : isCorrect
                              ? Icons.check_circle
                              : Icons.cancel,
                      size: 18,
                      color: isSkipped
                          ? AppColors.textSecondary
                          : isCorrect
                              ? AppColors.correctBorder
                              : AppColors.wrongBorder,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (eq.question.hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      eq.question.imagePath,
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 40),
                    ),
                  )
                else
                  Text(
                    eq.question.question,
                    style: GoogleFonts.notoSansKhmer(
                        fontSize: 13, color: AppColors.textPrimary, height: 1.5),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 10),
                _AnswerRow(
                  label: 'ចម្លើយត្រឹមត្រូវ',
                  text: options[eq.question.answer],
                  optionLabel: labels[eq.question.answer],
                  isCorrect: true,
                ),
                if (!isCorrect && !isSkipped) ...[
                  const SizedBox(height: 6),
                  _AnswerRow(
                    label: 'ចម្លើយរបស់អ្នក',
                    text: options[eq.selectedAnswer!],
                    optionLabel: labels[eq.selectedAnswer!],
                    isCorrect: false,
                  ),
                ],
              ],
            ),
          );
        }),
        // Show remaining questions as "not reached"
        if (answeredUpTo < total)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Text('⏭️', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Text(
                  'សំណួរ ${answeredUpTo + 1}–$total: មិនទាន់ឆ្លើយ (ការប្រឡងបញ្ចប់ដោយអាទិភាព)',
                  style: GoogleFonts.notoSansKhmer(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.offAllNamed('/'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.divider),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('ទំព័រដើម', style: GoogleFonts.notoSansKhmer(fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.delete<ExamController>();
                Get.offAllNamed('/exam');
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('ប្រឡងម្ដងទៀត',
                  style: GoogleFonts.notoSansKhmer(fontSize: 14, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.exam,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable answer row widget
class _AnswerRow extends StatelessWidget {
  final String label;
  final String text;
  final String optionLabel;
  final bool isCorrect;
  const _AnswerRow({
    required this.label,
    required this.text,
    required this.optionLabel,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppColors.correctBorder : AppColors.wrongBorder;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isCorrect ? Icons.check_circle : Icons.cancel,
          color: color,
          size: 14,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label ($optionLabel): ',
                  style: GoogleFonts.notoSansKhmer(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: GoogleFonts.notoSansKhmer(fontSize: 12, color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;
  const _StatBox(this.emoji, this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text('$value',
                style: GoogleFonts.notoSansKhmer(
                    fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label,
                style: GoogleFonts.notoSansKhmer(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
