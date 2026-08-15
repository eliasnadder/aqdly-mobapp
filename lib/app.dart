import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/language/language_bloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'bloc/analysis/analysis_bloc.dart';
import 'bloc/comparison/comparison_bloc.dart';
import 'bloc/chat/chat_bloc.dart';
import 'bloc/history/history_bloc.dart';
import 'routes/app_routes.dart';
import 'services/backend_repository.dart';
import 'services/history_store.dart';
import 'services/api_client.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  final SharedPreferences prefs;

  const App({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(prefs: prefs);
    final backendRepository = BackendRepository(apiClient);
    final historyStore = HistoryStore(prefs);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeBloc()..add(const LoadThemeMode()),
        ),
        BlocProvider(
          create: (_) =>
              LanguageBloc()..add(ChangeLanguage(const Locale('en', 'US'))),
        ),
        BlocProvider(
          create: (_) => AnalysisBloc(
            repo: backendRepository,
            history: historyStore,
          ),
        ),
        BlocProvider(
          create: (_) => ComparisonBloc(
            repo: backendRepository,
          ),
        ),
        BlocProvider(
          create: (_) => ChatBloc(
            repo: backendRepository,
          ),
        ),
        BlocProvider(
          create: (_) => HistoryBloc(
            store: historyStore,
          ),
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
