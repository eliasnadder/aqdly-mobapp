import 'package:flutter/material.dart';

import '../screens/ai_chat_screen.dart';
import '../screens/analysis_results_screen.dart';
import '../screens/ar_clause_details_screen.dart';
import '../screens/ar_contract_comparison_screen.dart';
import '../screens/ar_dashboard_screen.dart';
import '../screens/ar_operations_log_screen.dart';
import '../screens/clause_details_screen.dart';
import '../screens/contract_comparison_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_dashboard_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/profile_settings_screen.dart';
import '../screens/screen_gallery.dart';
import '../screens/upload_document_screen.dart';

class AppRoutes {
  static const home = '/';
  static const onboarding = '/onboarding';
  static const homeDashboard = '/home-dashboard';
  static const uploadDocument = '/upload-document';
  static const analysisResults = '/analysis-results';
  static const contractComparison = '/contract-comparison';
  static const aiChat = '/ai-chat';
  static const history = '/history';
  static const clauseDetails = '/clause-details';
  static const profileSettings = '/profile-settings';
  static const arDashboard = '/ar-dashboard';
  static const arOperationsLog = '/ar-operations-log';
  static const arClauseDetails = '/ar-clause-details';
  static const arContractComparison = '/ar-contract-comparison';

  static final routes = <String, WidgetBuilder>{
    home: (context) => const ScreenGallery(),
    onboarding: (context) => const OnboardingScreen(),
    homeDashboard: (context) => const HomeDashboardScreen(),
    uploadDocument: (context) => const UploadDocumentScreen(),
    analysisResults: (context) => const AnalysisResultsScreen(),
    contractComparison: (context) => const ContractComparisonScreen(),
    aiChat: (context) => const AiChatScreen(),
    history: (context) => const HistoryScreen(),
    clauseDetails: (context) => const ClauseDetailsScreen(),
    profileSettings: (context) => const ProfileSettingsScreen(),
    arDashboard: (context) => const ArabicDashboardScreen(),
    arOperationsLog: (context) => const ArabicOperationsLogScreen(),
    arClauseDetails: (context) => const ArabicClauseDetailsScreen(),
    arContractComparison: (context) => const ArabicContractComparisonScreen(),
  };
}
