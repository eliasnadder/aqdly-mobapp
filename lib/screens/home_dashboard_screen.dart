import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/history/history_bloc.dart';
import '../l10n/app_localizations.dart';
import '../models/analysis_models.dart';
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
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded) {
            return _buildDashboard(context, state.entries, l10n);
          }
          return _buildDashboard(context, [], l10n);
        },
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }

  static Widget _buildDashboard(
    BuildContext context,
    List<HistoryEntry> entries,
    AppLocalizations l10n,
  ) {
    final recentEntries = entries.take(3).toList();
    final activeReviews = _countActiveReviews(entries);

    return ListView(
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
          title: l10n.overview,
          subtitle: l10n.liveContractMonitoring,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: l10n.activeReviews,
                value: activeReviews.toString(),
                trend: l10n.monitoringActive,
                accent: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: l10n.riskAlerts,
                value: _countHighRisk(entries).toString(),
                trend: l10n.priorityItems,
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
          children: [
            _ActionChip(
              label: l10n.uploadContract,
              icon: Icons.upload_file,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.uploadDocument),
            ),
            _ActionChip(
              label: l10n.compareVersions,
              icon: Icons.swap_horiz,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.contractComparison),
            ),
            _ActionChip(
              label: l10n.startAiChat,
              icon: Icons.chat_bubble,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.aiChat),
            ),
            _ActionChip(
              label: l10n.exportReport,
              icon: Icons.share,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 20),
        AppSectionHeader(
          title: l10n.recentAnalyses,
          subtitle: l10n.latestAIGeneratedSummaries,
        ),
        const SizedBox(height: 12),
        if (recentEntries.isEmpty)
          AppCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.history_outlined, size: 48, color: AppColors.outline),
                    const SizedBox(height: 12),
                    Text(l10n.noRecentAnalyses, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.uploadDocument),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.analyzeFirstContract),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...recentEntries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RecentAnalysisTile(entry: entry),
            ),
          ),
      ],
    );
  }

  static int _countActiveReviews(List<HistoryEntry> entries) {
    // Count entries from the last 7 days as "active"
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return entries.where((e) => e.savedAt.isAfter(weekAgo)).length;
  }

  static int _countHighRisk(List<HistoryEntry> entries) {
    return entries
        .where((e) => e.result.clauses.any((c) => c.riskLevel.toLowerCase() == 'high'))
        .length;
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
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
  final VoidCallback? onTap;

  const _ActionChip({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _RecentAnalysisTile extends StatelessWidget {
  final HistoryEntry entry;

  const _RecentAnalysisTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = entry.result;
    final stats = result.stats;
    final complianceScore = result.complianceScore;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _generateTitle(result, l10n),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            _generateDetail(result, stats, l10n),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TagChip(
                label: _statusLabel(complianceScore, l10n),
                color: _statusColor(complianceScore),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(entry.savedAt, l10n),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _generateTitle(AnalysisResult result, AppLocalizations l10n) {
    final clauses = result.clauses;
    if (clauses.isEmpty) return l10n.contractAnalysis;
    return '${clauses.first.sectionTitle ?? l10n.clause} - ${clauses.length} ${l10n.clausesCount}';
  }

  static String _generateDetail(AnalysisResult result, AnalysisStats stats, AppLocalizations l10n) {
    return '${l10n.complianceScore}: ${result.complianceScore}% | ${stats.highRisk} ${l10n.highRisk} | ${stats.mediumRisk} ${l10n.mediumRisk}';
  }

  static String _statusLabel(int complianceScore, AppLocalizations l10n) {
    if (complianceScore >= 80) return l10n.completed;
    if (complianceScore >= 60) return l10n.needsReview;
    return l10n.critical;
  }

  static Color _statusColor(int complianceScore) {
    if (complianceScore >= 80) return AppColors.riskLow;
    if (complianceScore >= 60) return AppColors.riskMedium;
    return AppColors.riskHigh;
  }

  static String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return '${l10n.today}, ${_formatTimeOfDay(date)}';
    }
    final yesterday = today.subtract(const Duration(days: 1));
    if (entryDate == yesterday) {
      return '${l10n.yesterday}, ${_formatTimeOfDay(date)}';
    }
    return '${date.month}/${date.day}/${date.year}';
  }

  static String _formatTimeOfDay(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}