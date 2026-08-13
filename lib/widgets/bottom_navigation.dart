import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../routes/app_routes.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        final route = switch (index) {
          0 => AppRoutes.homeDashboard,
          1 => AppRoutes.uploadDocument,
          2 => AppRoutes.aiChat,
          3 => AppRoutes.profileSettings,
          _ => null,
        };
        if (route != null) {
          Navigator.of(context).pushNamed(route);
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_rounded),
          label: l10n.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.upload_file_outlined),
          selectedIcon: const Icon(Icons.upload_file),
          label: l10n.upload,
        ),
        NavigationDestination(
          icon: const Icon(Icons.chat_bubble_outline_rounded),
          selectedIcon: const Icon(Icons.chat_bubble_rounded),
          label: l10n.chat,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline_rounded),
          selectedIcon: const Icon(Icons.person_rounded),
          label: l10n.profile,
        ),
      ],
    );
  }
}