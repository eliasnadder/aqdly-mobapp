import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/history/history_bloc.dart';
import '../l10n/app_localizations.dart';
import '../models/analysis_models.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/tag_chip.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        actions: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is HistoryLoaded && state.entries.isNotEmpty) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'clear') {
                      _showClearConfirmation(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'clear', child: Text(l10n.clearHistory)),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.riskHigh,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryLoaded) {
            if (state.entries.isEmpty) {
              return _buildEmptyState(context, l10n);
            }
            return _buildHistoryList(context, state.entries, l10n);
          }
          return _buildEmptyState(context, l10n);
        },
      ),
    );
  }

  static Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history_outlined, size: 64, color: AppColors.outline),
            const SizedBox(height: 16),
            Text(
              l10n.noHistoryYet,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.analyzeFirstContract,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/upload-document'),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.analyzeFirstContract),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildHistoryList(
    BuildContext context,
    List<HistoryEntry> entries,
    AppLocalizations l10n,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        AppSectionHeader(
          title: l10n.recentActivity,
          subtitle: l10n.sortedByMostRecent,
        ),
        const SizedBox(height: 12),
        ...entries.map(
          (entry) => _HistoryEntryTile(entry: entry),
        ),
      ],
    );
  }

  static void _showClearConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clearHistory),
        content: Text(l10n.clearHistoryConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<HistoryBloc>().add(const HistoryDeleteRequested('__clear_all__'));
            },
            child: Text(l10n.clear),
          ),
        ],
      ),
    );
  }
}

class _HistoryEntryTile extends StatelessWidget {
  final HistoryEntry entry;

  const _HistoryEntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = entry.result;
    final stats = result.stats;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _generateTitle(result, l10n),
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _generateDetail(result, stats, l10n),
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.delete,
                  icon: const Icon(Icons.delete_outline, color: AppColors.riskHigh),
                  onPressed: () => _showDeleteDialog(context, entry.id),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                TagChip(
                  label: _statusLabel(result.complianceScore, l10n),
                  color: _statusColor(result.complianceScore),
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

  static void _showDeleteDialog(BuildContext context, String id) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteEntry),
        content: Text(l10n.deleteEntryConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<HistoryBloc>().add(HistoryDeleteRequested(id));
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}