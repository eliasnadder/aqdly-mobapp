import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/analysis_models.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/metric_tile.dart';
import '../widgets/tag_chip.dart';

class AnalysisResultsScreen extends StatelessWidget {
  const AnalysisResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)?.settings.arguments as AnalysisResult?;
    final l10n = AppLocalizations.of(context)!;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.analysisResults)),
        body: Center(child: Text(l10n.noAnalysisData)),
      );
    }

    final clauses = result.clauses;

    // Derive metrics from actual data
    final highRiskCount = clauses.where((c) => c.riskLevel.toLowerCase() == 'high').length;
    final mediumRiskCount = clauses.where((c) => c.riskLevel.toLowerCase() == 'medium').length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analysisResults),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppSectionHeader(
            title: l10n.summaryScore,
            subtitle: l10n.aiConfidenceRiskPosture,
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MetricTile(
                  label: l10n.overallCompliance,
                  value: '${result.complianceScore}%',
                  trailing: TagChip(
                    label: _complianceLabel(result.complianceScore),
                    color: _complianceColor(result.complianceScore),
                  ),
                ),
                const SizedBox(height: 16),
                MetricTile(
                  label: l10n.criticalIssues,
                  value: highRiskCount.toString(),
                  trailing: TagChip(
                    label: highRiskCount > 0 ? l10n.high : l10n.none,
                    color: highRiskCount > 0 ? AppColors.riskHigh : AppColors.riskLow,
                  ),
                ),
                const SizedBox(height: 16),
                MetricTile(
                  label: l10n.negotiableClauses,
                  value: mediumRiskCount.toString(),
                  trailing: TagChip(
                    label: mediumRiskCount > 0 ? l10n.medium : l10n.none,
                    color: mediumRiskCount > 0 ? AppColors.riskMedium : AppColors.riskLow,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppSectionHeader(
            title: l10n.keyFindings,
            subtitle: l10n.highestImpactClauses,
          ),
          const SizedBox(height: 12),
          ...clauses.map(
            (clause) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TagChip(
                          label: _riskLabel(clause.riskLevel, l10n),
                          color: _riskColor(clause.riskLevel),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          clause.sectionTitle ?? '',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      clause.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      clause.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.suggestedNextSteps,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ..._buildNextSteps(result.contractSummary, highRiskCount, mediumRiskCount, l10n).map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            step,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _complianceLabel(int score) {
    if (score >= 80) return 'Good';
    if (score >= 60) return 'Moderate';
    return 'Poor';
  }

  static Color _complianceColor(int score) {
    if (score >= 80) return AppColors.riskLow;
    if (score >= 60) return AppColors.riskMedium;
    return AppColors.riskHigh;
  }

  static String _riskLabel(String riskLevel, AppLocalizations l10n) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return l10n.high;
      case 'medium':
        return l10n.medium;
      case 'low':
        return l10n.low;
      default:
        return riskLevel;
    }
  }

  static Color _riskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
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

  static List<String> _buildNextSteps(
    ContractSummary? summary,
    int highRisk,
    int mediumRisk,
    AppLocalizations l10n,
  ) {
    final steps = <String>[];
    if (highRisk > 0) {
      steps.add(l10n.shareHighRiskWithCounsel);
    }
    if (highRisk > 0 || mediumRisk > 0) {
      steps.add(l10n.requestRedlinesForHighRisk);
    }
    steps.add(l10n.scheduleFollowUpAnalysis);
    if (highRisk > 0) {
      steps.add(l10n.reviewKeyRisks(highRisk));
    }
    return steps;
  }
}