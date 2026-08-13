import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/tag_chip.dart';

class ArabicClauseDetailsScreen extends StatelessWidget {
  const ArabicClauseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تفاصيل البند')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const AppSectionHeader(
              title: 'البند 6.2 - المسؤولية',
              subtitle: 'تم تصنيفه عالي المخاطر',
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Text(
                'يتحمل المورد جميع الأضرار المباشرة، ويجب ألا يقل سقف المسؤولية عن 2.5 ضعف قيمة العقد السنوية. تستثنى الأضرار غير المباشرة باستثناء خروقات البيانات.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                TagChip(label: 'مخاطر عالية', color: AppColors.riskHigh),
                SizedBox(width: 8),
                TagChip(label: 'يتطلب تفاوض', color: AppColors.riskMedium),
              ],
            ),
            const SizedBox(height: 20),
            const AppSectionHeader(
              title: 'توصيات الذكاء الاصطناعي',
              subtitle: 'تعديلات مقترحة وأسبابها',
            ),
            const SizedBox(height: 12),
            ..._recommendations.map(
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
                        item.detail,
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

class _Recommendation {
  final String title;
  final String detail;

  const _Recommendation({required this.title, required this.detail});
}

const _recommendations = [
  _Recommendation(
    title: 'تخفيض سقف المسؤولية',
    detail: 'اقتراح حد أقصى 1.5 ضعف الرسوم السنوية وفق سياسة الشركة.',
  ),
  _Recommendation(
    title: 'إضافة تعويض متبادل',
    detail: 'حماية الطرفين من مطالبات الجهات الخارجية.',
  ),
  _Recommendation(
    title: 'تحديد زمن الإبلاغ',
    detail: 'إلزام المورد بالإبلاغ خلال 72 ساعة عند حدوث خرق.',
  ),
];
