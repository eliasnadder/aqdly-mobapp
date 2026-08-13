import 'package:flutter/material.dart';

import '../widgets/app_section_header.dart';
import '../widgets/timeline_item.dart';

class ArabicOperationsLogScreen extends StatelessWidget {
  const ArabicOperationsLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('سجل العمليات')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            AppSectionHeader(
              title: 'نشاط اليوم',
              subtitle: 'تتبع خطوات التحليل والمراجعة',
            ),
            SizedBox(height: 16),
            TimelineItem(
              time: '09:10',
              title: 'تم رفع عقد جديد',
              subtitle: 'مشروع توريد المعدات - نسخة أولية.',
            ),
            TimelineItem(
              time: '10:05',
              title: 'تحليل المخاطر اكتمل',
              subtitle: 'تم اكتشاف بندين عاليي المخاطر.',
            ),
            TimelineItem(
              time: '11:40',
              title: 'تمت مشاركة الملخص',
              subtitle: 'تم إرسال التقرير إلى الفريق القانوني.',
            ),
            TimelineItem(
              time: '01:20',
              title: 'بدء مقارنة النسخ',
              subtitle: 'مقارنة النسخة الحالية مع نسخة العام الماضي.',
            ),
          ],
        ),
      ),
    );
  }
}
