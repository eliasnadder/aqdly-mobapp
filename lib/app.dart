import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/language/language_bloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeBloc()..add(const LoadThemeMode()),
        ),
        BlocProvider(
          create: (_) =>
              LanguageBloc()..add(ChangeLanguage(const Locale('en', 'US'))),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                title: 'Aqdly',
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: languageState is LanguageChanged
                    ? languageState.locale
                    : const Locale('en', 'US'),
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeState is ThemeChanged
                    ? themeState.themeMode
                    : ThemeMode.system,
                initialRoute: AppRoutes.homeDashboard,
                routes: AppRoutes.routes,
              );
            },
          );
        },
      ),
    );
  }
}
