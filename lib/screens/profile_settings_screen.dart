import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../bloc/language/language_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../config/api_config.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/app_section_header.dart';
import '../widgets/setting_tile.dart';
import '../widgets/bottom_navigation.dart';

String _initials(String? name) {
  final trimmed = name?.trim() ?? '';
  if (trimmed.isEmpty) return '?';
  final parts = trimmed.split(RegExp(r'\s+'));
  final first = parts.first.isNotEmpty ? parts.first[0] : '';
  if (parts.length == 1) return first.toUpperCase();
  final last = parts.last.isNotEmpty ? parts.last[0] : '';
  return (first + last).toUpperCase();
}

String _themeModeLabel(AppLocalizations l10n, ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return l10n.light;
    case ThemeMode.dark:
      return l10n.dark;
    case ThemeMode.system:
      return l10n.system;
  }
}

void _showAppearanceSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final bloc = BlocProvider.of<ThemeBloc>(context);
  ThemeMode current = ThemeMode.system;
  final state = bloc.state;
  if (state is ThemeChanged) current = state.themeMode;

  const options = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: RadioGroup<ThemeMode>(
        groupValue: current,
        onChanged: (ThemeMode? selected) {
          if (selected == null) return;
          bloc.add(ChangeThemeMode(selected));
          Navigator.of(sheetContext).pop();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.appearance,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            for (final mode in options)
              RadioListTile<ThemeMode>(
                value: mode,
                title: Text(_themeModeLabel(l10n, mode)),
              ),
          ],
        ),
      ),
    ),
  );
}

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppSectionHeader(
            title: l10n.profile,
            subtitle: l10n.manageWorkspacePreferences,
          ),
          const SizedBox(height: 12),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              final displayName = user?.displayName;
              final email = user?.email;
              final photoUrl = user?.photoURL;
              return AppCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.secondary,
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl)
                          : null,
                      child: photoUrl != null
                          ? null
                          : Text(
                              _initials(displayName),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName ?? 'User',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(email ?? ''),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          AppSectionHeader(
            title: l10n.workspace,
            subtitle: l10n.alertsAndIntegrations,
          ),
          const SizedBox(height: 12),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SettingTile(
                  icon: Icons.notifications_outlined,
                  title: l10n.alertsNotifications,
                  subtitle: l10n.highRiskClauseAlerts,
                ),
                Divider(height: 1),
                SettingTile(
                  icon: Icons.language,
                  title: l10n.language,
                  subtitle: l10n.englishArabic,
                  onTap: () {
                    final languageBloc = BlocProvider.of<LanguageBloc>(context);
                    final currentState = languageBloc.state;
                    final currentLocale = currentState is LanguageChanged
                        ? currentState.locale
                        : const Locale('en', 'US');
                    final newLocale = currentLocale.languageCode == 'en'
                        ? const Locale('ar', 'SA')
                        : const Locale('en', 'US');
                    languageBloc.add(ChangeLanguage(newLocale));
                  },
                ),
                Divider(height: 1),
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    final mode = themeState is ThemeChanged
                        ? themeState.themeMode
                        : ThemeMode.system;
                    return SettingTile(
                      icon: Icons.brightness_6_outlined,
                      title: l10n.appearance,
                      subtitle: _themeModeLabel(l10n, mode),
                      onTap: () => _showAppearanceSheet(context),
                    );
                  },
                ),
                Divider(height: 1),
                _BackendUrlTile(),
                Divider(height: 1),
                SettingTile(
                  icon: Icons.lock_outline,
                  title: l10n.security,
                  subtitle: l10n.securityEnabled,
                ),
                Divider(height: 1),
                SettingTile(
                  icon: Icons.integration_instructions_outlined,
                  title: l10n.integrations,
                  subtitle: l10n.integrationsConnected,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
    );
  }
}

class _BackendUrlTile extends StatefulWidget {
  const _BackendUrlTile();

  @override
  State<_BackendUrlTile> createState() => _BackendUrlTileState();
}

class _BackendUrlTileState extends State<_BackendUrlTile> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString(kApiBaseUrlPrefKey) ?? kDefaultApiBaseUrl;
    if (mounted) {
      _controller.text = url;
    }
  }

  Future<void> _saveUrl() async {
    final url = _controller.text.trim();
    if (url.isEmpty) return;

    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kApiBaseUrlPrefKey, url);
    ApiClient.updateBaseUrl(url);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.backendUrlSaved)),
      );
    }
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SettingTile(
      icon: Icons.cloud_outlined,
      title: l10n.backendUrl,
      subtitle: _controller.text.isEmpty ? l10n.backendUrlHint : _controller.text,
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.backendUrl),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: l10n.backendUrlHint,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: _saving ? null : () {
                  Navigator.of(dialogContext).pop();
                  _saveUrl();
                },
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.save),
              ),
            ],
          ),
        );
      },
    );
  }
}
