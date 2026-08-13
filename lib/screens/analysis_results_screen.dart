import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/metric_tile.dart';
import '../widgets/tag_chip.dart';

class AnalysisResultsScreen extends StatelessWidget {
  const AnalysisResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
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
          const AppSectionHeader(
            title: 'Summary Score',
            subtitle: 'AI confidence and risk posture',
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MetricTile(
                  label: 'Overall Compliance',
                  value: '82%',
                  trailing: TagChip(label: 'Stable', color: AppColors.riskLow),
                ),
                const SizedBox(height: 16),
                const MetricTile(
                  label: 'Critical Issues',
                  value: '2',
                  trailing: TagChip(label: 'High', color: AppColors.riskHigh),
                ),
                const SizedBox(height: 16),
                const MetricTile(
                  label: 'Negotiable Clauses',
                  value: '7',
                  trailing: TagChip(
                    label: 'Medium',
                    color: AppColors.riskMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const AppSectionHeader(
            title: 'Key Findings',
            subtitle: 'Highest impact clauses and recommendations',
          ),
          const SizedBox(height: 12),
          ..._findings.map(
            (finding) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TagChip(label: finding.severity, color: finding.color),
                        const SizedBox(width: 8),
                        Text(
                          finding.section,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      finding.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      finding.detail,
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
                  'Suggested Next Steps',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ..._nextSteps.map(
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
}

class _Finding {
  final String section;
  final String title;
  final String detail;
  final String severity;
  final Color color;

  const _Finding({
    required this.section,
    required this.title,
    required this.detail,
    required this.severity,
    required this.color,
  });
}

const _findings = [
  _Finding(
    section: 'Section 4.3',
    title: 'Unlimited liability for data breach',
    detail:
        'Recommend capping liability to 2x annual contract value to align with policy.',
    severity: 'High',
    color: AppColors.riskHigh,
  ),
  _Finding(
    section: 'Section 7.1',
    title: 'Auto-renewal without notice period',
    detail: 'Insert 60-day written notice to protect termination flexibility.',
    severity: 'Medium',
    color: AppColors.riskMedium,
  ),
  _Finding(
    section: 'Section 9.5',
    title: 'Subprocessor disclosure window',
    detail: 'Shorten disclosure timeline from 30 to 10 days for compliance.',
    severity: 'Medium',
    color: AppColors.riskMedium,
  ),
];

const _nextSteps = [
  'Share high-risk findings with legal counsel for negotiation playbook.',
  'Request updated vendor redlines for Section 4.3 and Section 7.1.',
  'Schedule follow-up analysis after revisions are received.',
];
