import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/tag_chip.dart';

class ClauseDetailsScreen extends StatelessWidget {
  const ClauseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clause Details'),
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AppSectionHeader(
            title: 'Clause 6.2 - Liability',
            subtitle: 'Flagged for high risk exposure',
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Text(
              'The supplier shall be liable for all direct damages, and in no event shall the liability cap be less than 2.5x the annual contract value. Indirect damages are excluded except for data breaches.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              TagChip(label: 'High Risk', color: AppColors.riskHigh),
              SizedBox(width: 8),
              TagChip(label: 'Needs Negotiation', color: AppColors.riskMedium),
            ],
          ),
          const SizedBox(height: 20),
          const AppSectionHeader(
            title: 'AI Recommendations',
            subtitle: 'Suggested edits and rationale',
          ),
          const SizedBox(height: 12),
          ..._recommendations.map(
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
                      item.detail,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Recommendation {
  final String title;
  final String detail;

  const _Recommendation({required this.title, required this.detail});
}

const _recommendations = [
  _Recommendation(
    title: 'Reduce liability cap',
    detail:
        'Align with policy by proposing a maximum of 1.5x annual fees, with carve-outs for gross negligence only.',
  ),
  _Recommendation(
    title: 'Add mutual indemnity',
    detail:
        'Introduce reciprocal indemnity language to protect against third-party claims.',
  ),
  _Recommendation(
    title: 'Clarify breach response',
    detail:
        'Specify a 72-hour notification timeline and require forensics cooperation.',
  ),
];
