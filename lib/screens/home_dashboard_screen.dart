import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/tag_chip.dart';
import '../widgets/bottom_navigation.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: l10n.history,
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.history),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.welcomeBack,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          const _AnalyzeContractCard(),
          const SizedBox(height: 20),
          AppSectionHeader(
            title: 'Overview',
            subtitle: 'Live contract monitoring snapshots',
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: StatCard(
                  title: 'Active Reviews',
                  value: '18',
                  trend: '+4 since yesterday',
                  accent: AppColors.secondary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Risk Alerts',
                  value: '6',
                  trend: '2 high priority',
                  accent: AppColors.riskHigh,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppSectionHeader(
            title: l10n.quickActions,
            subtitle: l10n.launchCoreAIWorkflows,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _ActionChip(label: 'Upload Contract', icon: Icons.upload_file),
              _ActionChip(label: 'Compare Versions', icon: Icons.swap_horiz),
              _ActionChip(label: 'Start AI Chat', icon: Icons.chat_bubble),
              _ActionChip(label: 'Export Report', icon: Icons.share),
            ],
          ),
          const SizedBox(height: 20),
          AppSectionHeader(
            title: l10n.recentAnalyses,
            subtitle: l10n.latestAIGeneratedSummaries,
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
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }
}

class _AnalyzeContractCard extends StatelessWidget {
  const _AnalyzeContractCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.document_scanner_outlined,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.analyzeNewContract,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.uploadDocument,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.uploadDocument,
              ),
              icon: const Icon(Icons.upload_file_rounded),
              label: Text(l10n.uploadDocument),
            ),
          ),
        ],
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
    title: 'Supplier Agreement - V3',
    summary: 'Three clauses flagged for escalation. Renewal window unchanged.',
    status: 'Medium Risk',
    time: '12 min ago',
    color: AppColors.riskMedium,
  ),
  _AnalysisItem(
    title: 'NDA - Global Partner',
    summary: 'No critical variances detected. 94% alignment score.',
    status: 'Low Risk',
    time: '2 hrs ago',
    color: AppColors.riskLow,
  ),
  _AnalysisItem(
    title: 'Service Level Addendum',
    summary: 'Liability cap increased by 15%. Recommend negotiation.',
    status: 'High Risk',
    time: 'Yesterday',
    color: AppColors.riskHigh,
  ),
];
