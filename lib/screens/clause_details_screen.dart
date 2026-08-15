import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/analysis_models.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/tag_chip.dart';

class ClauseDetailsScreen extends StatelessWidget {
  const ClauseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clause = ModalRoute.of(context)?.settings.arguments as AnalyzedClause?;
    final l10n = AppLocalizations.of(context)!;

    if (clause == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.clauseDetails)),
        body: Center(child: Text(l10n.noClauseData)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.clauseDetails),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppSectionHeader(
            title: clause.title,
            subtitle: clause.sectionTitle ?? l10n.riskTagHigh,
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Text(
              clause.description ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TagChip(
                label: _riskLabel(clause.riskLevel, l10n),
                color: _riskColor(clause.riskLevel),
              ),
              if ((clause.recommendation ?? '').isNotEmpty) ...[
                const SizedBox(width: 8),
                TagChip(label: l10n.needsAction, color: AppColors.riskMedium),
              ],
            ],
          ),
          if ((clause.recommendation ?? '').isNotEmpty) ...[
            const SizedBox(height: 20),
            AppSectionHeader(
              title: l10n.aiRecommendations,
              subtitle: l10n.suggestedEditsRationale,
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.recommendation,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    clause.recommendation ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
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
}
