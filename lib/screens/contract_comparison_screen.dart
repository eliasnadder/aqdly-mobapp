import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/comparison/comparison_bloc.dart';
import '../l10n/app_localizations.dart';
import '../models/analysis_models.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/tag_chip.dart';

class ContractComparisonScreen extends StatelessWidget {
  const ContractComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contractComparison),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ComparisonBloc, ComparisonState>(
        builder: (context, state) {
          if (state is ComparisonLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ComparisonError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.riskHigh),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                ],
              ),
            );
          }
          if (state is ComparisonSuccess) {
            return _buildComparisonView(context, state.result, l10n);
          }
          // Initial state - no comparison run yet
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.compare_arrows, size: 64, color: AppColors.secondary),
                  const SizedBox(height: 16),
                  Text(l10n.noComparisonData, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Text(
                    l10n.compareTwoContracts,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildComparisonView(
    BuildContext context,
    ComparisonResult result,
    AppLocalizations l10n,
  ) {
    final contract1 = result.contract1;
    final contract2 = result.contract2;
    final differences = result.differences;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        AppSectionHeader(
          title: l10n.sideBySideView,
          subtitle: l10n.clauseDifferencesAiSummary,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ContractCard(
                title: contract1.filename,
                version: l10n.unknownVersion,
                status: _statusFromScore(contract1.complianceScore, l10n),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ContractCard(
                title: contract2.filename,
                version: l10n.unknownVersion,
                status: _statusFromScore(contract2.complianceScore, l10n),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        AppSectionHeader(
          title: l10n.diffHighlights,
          subtitle: l10n.aiSummarizedDeltas,
        ),
        const SizedBox(height: 12),
        if (differences.isEmpty) ...[
          AppCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.noSignificantDifferences),
              ),
            ),
          ),
        ] else ...[
          ...differences.map(
            (diff) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TagChip(
                          label: _impactLabel(diff.impact, l10n),
                          color: _impactColor(diff.impact),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          diff.type,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diff.message,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    if (diff.changeDetail != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.inContract1,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                ),
                                Text(
                                  diff.changeDetail!.contract1Value,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.inContract2,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline),
                                ),
                                Text(
                                  diff.changeDetail!.contract2Value,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.aiSummary,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                result.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _statusFromScore(int score, AppLocalizations l10n) {
    if (score >= 80) return l10n.completed;
    if (score >= 60) return l10n.needsReview;
    return l10n.critical;
  }

  static String _impactLabel(String impact, AppLocalizations l10n) {
    switch (impact.toLowerCase()) {
      case 'high':
        return l10n.high;
      case 'medium':
        return l10n.medium;
      case 'low':
        return l10n.low;
      default:
        return impact;
    }
  }

  static Color _impactColor(String impact) {
    switch (impact.toLowerCase()) {
      case 'high':
        return AppColors.riskHigh;
      case 'medium':
        return AppColors.riskMedium;
      case 'low':
        return AppColors.riskLow;
      default:
        return AppColors.riskMedium;
    }
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
            color: status.toLowerCase() == 'needs review' || status.toLowerCase() == 'needs action' ? AppColors.riskMedium : AppColors.riskLow,
          ),
        ],
      ),
    );
  }
}