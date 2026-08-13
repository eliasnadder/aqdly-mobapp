import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'l10n/app_localizations.dart';
import 'screens/auth_screen.dart';
import 'screens/onboarding_screen.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  Future<bool> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }

  Future<bool> _isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStatus = prefs.getBool('user_authenticated') ?? false;
    if (savedStatus) {
      return true;
    }

    if (Firebase.apps.isEmpty) {
      return false;
    }

    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  MaterialApp _buildLocalizedApp({required Widget home}) {
    return MaterialApp(
      title: 'Aqdly',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en', 'US'),
      home: home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isAuthenticated(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLocalizedApp(
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final isAuthenticated = authSnapshot.data ?? false;
        if (!isAuthenticated) {
          return _buildLocalizedApp(home: const AuthScreen());
        }

        return FutureBuilder<bool>(
          future: _checkOnboardingStatus(),
          builder: (context, onboardingSnapshot) {
            if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLocalizedApp(
                home: const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            final onboardingCompleted = onboardingSnapshot.data ?? false;
            if (!onboardingCompleted) {
              return _buildLocalizedApp(home: const OnboardingScreen());
            }

            return const App();
          },
        );
      },
    );
  }
}
