import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class ScreenGallery extends StatelessWidget {
  const ScreenGallery({super.key});

  static const _screens = [
    _ScreenEntry('Home Dashboard', AppRoutes.homeDashboard),
    _ScreenEntry('Upload Document', AppRoutes.uploadDocument),
    _ScreenEntry('Analysis Results', AppRoutes.analysisResults),
    _ScreenEntry('Contract Comparison', AppRoutes.contractComparison),
    _ScreenEntry('AI Chat Interface', AppRoutes.aiChat),
    _ScreenEntry('History', AppRoutes.history),
    _ScreenEntry('Clause Details', AppRoutes.clauseDetails),
    _ScreenEntry('Profile & Settings', AppRoutes.profileSettings),
    _ScreenEntry('لوحة التحكم (Arabic)', AppRoutes.arDashboard, isArabic: true),
    _ScreenEntry(
      'سجل العمليات (Arabic)',
      AppRoutes.arOperationsLog,
      isArabic: true,
    ),
    _ScreenEntry(
      'تفاصيل البند (Arabic)',
      AppRoutes.arClauseDetails,
      isArabic: true,
    ),
    _ScreenEntry(
      'مقارنة العقود (Arabic)',
      AppRoutes.arContractComparison,
      isArabic: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AraContract Analyzer AI')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          final entry = _screens[index];
          return AppCard(
            padding: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(entry.title),
              subtitle: Text(entry.isArabic ? 'RTL layout' : 'LTR layout'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).pushNamed(entry.route),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemCount: _screens.length,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.surfaceVariant)),
        ),
        child: Text(
          'Stitch assets are stored in assets/stitch for reference.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _ScreenEntry {
  final String title;
  final String route;
  final bool isArabic;

  const _ScreenEntry(this.title, this.route, {this.isArabic = false});
}
