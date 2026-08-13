import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/tag_chip.dart';

class ContractComparisonScreen extends StatelessWidget {
  const ContractComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract Comparison'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AppSectionHeader(
            title: 'Side-by-Side View',
            subtitle: 'Clause differences and AI summary',
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _ContractCard(
                  title: 'Master Services Agreement',
                  version: 'Version 2.2',
                  status: 'Active',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _ContractCard(
                  title: 'Master Services Agreement',
                  version: 'Version 3.0',
                  status: 'Draft',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const AppSectionHeader(
            title: 'Diff Highlights',
            subtitle: 'AI summarized deltas',
          ),
          const SizedBox(height: 12),
          ..._diffs.map(
            (diff) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TagChip(label: diff.impact, color: diff.color),
                        const SizedBox(width: 8),
                        Text(
                          diff.section,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diff.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      diff.detail,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 3.0 introduces a higher liability cap and expands SLA penalties. Consider escalating Section 6.2 before approval.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
            color: status == 'Draft' ? AppColors.riskMedium : AppColors.riskLow,
          ),
        ],
      ),
    );
  }
}

class _DiffItem {
  final String section;
  final String title;
  final String detail;
  final String impact;
  final Color color;

  const _DiffItem({
    required this.section,
    required this.title,
    required this.detail,
    required this.impact,
    required this.color,
  });
}

const _diffs = [
  _DiffItem(
    section: 'Clause 6.2',
    title: 'Liability cap increased',
    detail:
        'Cap raised from 1.5x to 2.5x annual fees. Requires finance approval.',
    impact: 'High',
    color: AppColors.riskHigh,
  ),
  _DiffItem(
    section: 'Clause 9.1',
    title: 'Audit rights expanded',
    detail:
        'Client may audit annually with 14-day notice, adds compliance burden.',
    impact: 'Medium',
    color: AppColors.riskMedium,
  ),
  _DiffItem(
    section: 'Clause 12.4',
    title: 'Termination notice updated',
    detail:
        'Notice period extended from 30 to 45 days for convenience termination.',
    impact: 'Low',
    color: AppColors.riskLow,
  ),
];
