import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_card.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? trend;
  final Color? accent;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.trend,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      background: accent?.withValues(alpha: 0.08) ?? AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.displaySmall),
          if (trend != null) ...[
            const SizedBox(height: 6),
            Text(
              trend!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: accent ?? AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
