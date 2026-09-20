import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../responsive.dart';
import 'study_screen.dart';
import 'exam_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.gridColumns(context);
    final pad = Responsive.pagePadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveCenterExpand(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(pad, 0, pad, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildListDelegate(_buildModuleCards()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final pad = Responsive.pagePadding(context);
    return Container(
      padding: EdgeInsets.fromLTRB(pad, 28, pad, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('🇰🇭', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ច្បាប់ចរាចរណ៍កម្ពុជា',
                    style: GoogleFonts.notoSansKhmer(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Cambodia Driving Rules',
                    style: GoogleFonts.notoSansKhmer(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Text('📝', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ការប្រឡង',
                        style: GoogleFonts.notoSansKhmer(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '45 សំណួរ • 45 នាទី • ត្រូវការ ≥38 ពិន្ទុ',
                        style: GoogleFonts.notoSansKhmer(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const ExamScreen()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'ចាប់ផ្តើម',
                      style: GoogleFonts.notoSansKhmer(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ជ្រើសរើសមេរៀនដែលអ្នកចង់សិក្សា',
            style: GoogleFonts.notoSansKhmer(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildModuleCards() {
    final modules = [
      _ModuleInfo('general', '72', 'ច្បាប់ទូទៅ', 'General Rules'),
      _ModuleInfo('sign', '100', 'សញ្ញាចរាចរណ៍', 'Road Signs'),
      _ModuleInfo('priority', '31', 'អាទិភាព', 'Priority'),
      _ModuleInfo('technique', '31', 'បច្ចេកទេស', 'Technique'),
      _ModuleInfo('emergency', '15', 'អាសន្ន', 'Emergency'),
    ];

    return modules.map((m) => _ModuleCard(info: m)).toList();
  }
}

class _ModuleInfo {
  final String category;
  final String count;
  final String title;
  final String subtitle;
  _ModuleInfo(this.category, this.count, this.title, this.subtitle);
}

class _ModuleCard extends StatelessWidget {
  final _ModuleInfo info;
  const _ModuleCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(info.category);
    final icon = categoryIcon(info.category);

    return GestureDetector(
      onTap: () => Get.to(() => StudyScreen(category: info.category)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    info.count,
                    style: GoogleFonts.notoSansKhmer(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  style: GoogleFonts.notoSansKhmer(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  info.subtitle,
                  style: GoogleFonts.notoSansKhmer(
                    fontSize: 11,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
