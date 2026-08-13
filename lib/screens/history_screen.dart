import 'package:flutter/material.dart';

import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/tag_chip.dart';
import '../theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AppSectionHeader(
            title: 'Recent Activity',
            subtitle: 'Sorted by most recent analysis',
          ),
          const SizedBox(height: 12),
          ..._items.map(
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
    );
  }
}

class _HistoryItem {
  final String title;
  final String detail;
  final String status;
  final String time;
  final Color color;

  const _HistoryItem({
    required this.title,
    required this.detail,
    required this.status,
    required this.time,
    required this.color,
  });
}

const _items = [
  _HistoryItem(
    title: 'Enterprise SaaS Renewal',
    detail: 'AI summary generated and shared with procurement.',
    status: 'Completed',
    time: 'Today, 08:40 AM',
    color: AppColors.riskLow,
  ),
  _HistoryItem(
    title: 'Vendor Data Processing Addendum',
    detail: 'Two clauses flagged for legal review.',
    status: 'Needs Review',
    time: 'Yesterday, 04:15 PM',
    color: AppColors.riskMedium,
  ),
  _HistoryItem(
    title: 'Hardware Supply Contract',
    detail: 'Negotiation checklist exported as PDF.',
    status: 'Exported',
    time: 'May 30, 02:10 PM',
    color: AppColors.secondary,
  ),
  _HistoryItem(
    title: 'NDA - Strategic Partner',
    detail: 'No critical issues found. Archived in repository.',
    status: 'Archived',
    time: 'May 29, 11:05 AM',
    color: AppColors.outline,
  ),
];
