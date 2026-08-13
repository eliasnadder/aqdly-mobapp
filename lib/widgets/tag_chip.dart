import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TagChip extends StatelessWidget {
  final String label;
  final Color? color;

  const TagChip({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? AppColors.secondary).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: color ?? AppColors.secondary),
      ),
    );
  }
}
