import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/tag_chip.dart';

class ArabicContractComparisonScreen extends StatelessWidget {
  const ArabicContractComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('مقارنة العقود')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const AppSectionHeader(
              title: 'عرض المقارنة',
              subtitle: 'الفروقات الرئيسية بين النسخ',
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  child: _ContractCard(
                    title: 'اتفاقية الخدمات الرئيسية',
                    version: 'نسخة 2.2',
                    status: 'نشط',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _ContractCard(
                    title: 'اتفاقية الخدمات الرئيسية',
                    version: 'نسخة 3.0',
                    status: 'مسودة',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const AppSectionHeader(
              title: 'أهم الفروقات',
              subtitle: 'ملخص الذكاء الاصطناعي',
            ),
            const SizedBox(height: 12),
            ..._diffs.map(
              (diff) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TagChip(label: diff.impact, color: diff.color),
                          const SizedBox(width: 8),
                          Text(
                            diff.section,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diff.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        diff.detail,
                        style: Theme.of(context).textTheme.bodyMedium,
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

class _ContractCard extends StatelessWidget {
  final String title;
  final String version;
  final String status;

  const _ContractCard({
    required this.title,
    required this.version,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(version, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          TagChip(
            label: status,
            color: status == 'مسودة' ? AppColors.riskMedium : AppColors.riskLow,
          ),
        ],
      ),
    );
  }
}

class _DiffItem {
  final String section;
  final String title;
  final String detail;
  final String impact;
  final Color color;

  const _DiffItem({
    required this.section,
    required this.title,
    required this.detail,
    required this.impact,
    required this.color,
  });
}

const _diffs = [
  _DiffItem(
    section: 'البند 6.2',
    title: 'زيادة سقف المسؤولية',
    detail: 'تم رفع السقف من 1.5x إلى 2.5x من الرسوم السنوية.',
    impact: 'مرتفع',
    color: AppColors.riskHigh,
  ),
  _DiffItem(
    section: 'البند 9.1',
    title: 'توسيع حقوق التدقيق',
    detail: 'تدقيق سنوي بإشعار 14 يوما.',
    impact: 'متوسط',
    color: AppColors.riskMedium,
  ),
  _DiffItem(
    section: 'البند 12.4',
    title: 'تمديد فترة الإنهاء',
    detail: 'تم تمديد الإشعار من 30 إلى 45 يوما.',
    impact: 'منخفض',
    color: AppColors.riskLow,
  ),
];
