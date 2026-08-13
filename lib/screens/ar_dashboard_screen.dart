import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/tag_chip.dart';

class ArabicDashboardScreen extends StatelessWidget {
  const ArabicDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التحكم'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const AppSectionHeader(
              title: 'نظرة عامة',
              subtitle: 'ملخص فوري لحالة العقود',
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    title: 'العقود النشطة',
                    value: '18',
                    trend: '+4 منذ الأمس',
                    accent: AppColors.secondary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'تنبيهات المخاطر',
                    value: '6',
                    trend: '2 عالية الأولوية',
                    accent: AppColors.riskHigh,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const AppSectionHeader(
              title: 'إجراءات سريعة',
              subtitle: 'ابدأ التحليلات الأساسية',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _ActionChip(label: 'رفع عقد', icon: Icons.upload_file),
                _ActionChip(label: 'مقارنة نسخ', icon: Icons.swap_horiz),
                _ActionChip(label: 'دردشة الذكاء', icon: Icons.chat_bubble),
                _ActionChip(label: 'تصدير تقرير', icon: Icons.share),
              ],
            ),
            const SizedBox(height: 20),
            const AppSectionHeader(
              title: 'أحدث التحليلات',
              subtitle: 'مخرجات الذكاء الاصطناعي',
            ),
            const SizedBox(height: 12),
            ..._recentAnalyses.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.summary,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          TagChip(label: item.status, color: item.color),
                          const SizedBox(width: 8),
                          Text(
                            item.time,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
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

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ActionChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _AnalysisItem {
  final String title;
  final String summary;
  final String status;
  final String time;
  final Color color;

  const _AnalysisItem({
    required this.title,
    required this.summary,
    required this.status,
    required this.time,
    required this.color,
  });
}

const _recentAnalyses = [
  _AnalysisItem(
    title: 'اتفاقية المورد - نسخة 3',
    summary: 'تمت الإشارة إلى 3 بنود تحتاج مراجعة قانونية.',
    status: 'مخاطر متوسطة',
    time: 'قبل 12 دقيقة',
    color: AppColors.riskMedium,
  ),
  _AnalysisItem(
    title: 'اتفاقية السرية',
    summary: 'لا توجد مخالفات كبيرة. نسبة التطابق 94%.',
    status: 'مخاطر منخفضة',
    time: 'قبل ساعتين',
    color: AppColors.riskLow,
  ),
  _AnalysisItem(
    title: 'ملحق مستوى الخدمة',
    summary: 'زيادة سقف المسؤولية بنسبة 15%. يفضل التفاوض.',
    status: 'مخاطر عالية',
    time: 'أمس',
    color: AppColors.riskHigh,
  ),
];
