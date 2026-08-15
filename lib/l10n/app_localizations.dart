import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Aqdly'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileSettings;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, Sarah.'**
  String get welcomeBack;

  /// No description provided for @analyzeNewContract.
  ///
  /// In en, this message translates to:
  /// **'Analyze New Contract'**
  String get analyzeNewContract;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @uploadDocumentOrPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Document or Photo'**
  String get uploadDocumentOrPhoto;

  /// No description provided for @newUpload.
  ///
  /// In en, this message translates to:
  /// **'New Upload'**
  String get newUpload;

  /// No description provided for @documentsAndPhotos.
  ///
  /// In en, this message translates to:
  /// **'Documents and photos — up to 10 MB each'**
  String get documentsAndPhotos;

  /// No description provided for @tapToChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose a file'**
  String get tapToChooseFile;

  /// No description provided for @readyToUpload.
  ///
  /// In en, this message translates to:
  /// **'Ready to upload'**
  String get readyToUpload;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File too large'**
  String get fileTooLarge;

  /// No description provided for @browseFiles.
  ///
  /// In en, this message translates to:
  /// **'Browse files'**
  String get browseFiles;

  /// No description provided for @uploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get uploadButton;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Uploaded successfully'**
  String get uploadSuccess;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @liveContractMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Live contract monitoring snapshots'**
  String get liveContractMonitoring;

  /// No description provided for @activeReviews.
  ///
  /// In en, this message translates to:
  /// **'Active Reviews'**
  String get activeReviews;

  /// No description provided for @riskAlerts.
  ///
  /// In en, this message translates to:
  /// **'Risk Alerts'**
  String get riskAlerts;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @launchCoreAIWorkflows.
  ///
  /// In en, this message translates to:
  /// **'Launch core AI workflows'**
  String get launchCoreAIWorkflows;

  /// No description provided for @recentAnalyses.
  ///
  /// In en, this message translates to:
  /// **'Recent Analyses'**
  String get recentAnalyses;

  /// No description provided for @latestAIGeneratedSummaries.
  ///
  /// In en, this message translates to:
  /// **'Latest AI-generated summaries'**
  String get latestAIGeneratedSummaries;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @manageWorkspacePreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage your workspace preferences'**
  String get manageWorkspacePreferences;

  /// No description provided for @workspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspace;

  /// No description provided for @alertsAndIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Alerts, language, and integrations'**
  String get alertsAndIntegrations;

  /// No description provided for @alertsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Alerts & Notifications'**
  String get alertsNotifications;

  /// No description provided for @highRiskClauseAlerts.
  ///
  /// In en, this message translates to:
  /// **'High risk clause alerts enabled'**
  String get highRiskClauseAlerts;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @englishArabic.
  ///
  /// In en, this message translates to:
  /// **'English (US) / العربية (RTL)'**
  String get englishArabic;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securityEnabled.
  ///
  /// In en, this message translates to:
  /// **'2FA enabled for admins'**
  String get securityEnabled;

  /// No description provided for @integrations.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get integrations;

  /// No description provided for @integrationsConnected.
  ///
  /// In en, this message translates to:
  /// **'DocuSign, SharePoint connected'**
  String get integrationsConnected;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @analysisResults.
  ///
  /// In en, this message translates to:
  /// **'Analysis Results'**
  String get analysisResults;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @clauses.
  ///
  /// In en, this message translates to:
  /// **'Clauses'**
  String get clauses;

  /// No description provided for @riskTagHigh.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get riskTagHigh;

  /// No description provided for @riskTagMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium Risk'**
  String get riskTagMedium;

  /// No description provided for @riskTagLow.
  ///
  /// In en, this message translates to:
  /// **'Low Risk'**
  String get riskTagLow;

  /// No description provided for @compareContracts.
  ///
  /// In en, this message translates to:
  /// **'Compare Contracts'**
  String get compareContracts;

  /// No description provided for @sideBySideView.
  ///
  /// In en, this message translates to:
  /// **'Side-by-Side View'**
  String get sideBySideView;

  /// No description provided for @diffHighlights.
  ///
  /// In en, this message translates to:
  /// **'Differences'**
  String get diffHighlights;

  /// No description provided for @typeAQuestion.
  ///
  /// In en, this message translates to:
  /// **'Type a question…'**
  String get typeAQuestion;

  /// No description provided for @analyzeButton.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get analyzeButton;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing…'**
  String get analyzing;

  /// No description provided for @startAiChat.
  ///
  /// In en, this message translates to:
  /// **'Start AI Chat'**
  String get startAiChat;

  /// No description provided for @backendUrl.
  ///
  /// In en, this message translates to:
  /// **'Backend URL'**
  String get backendUrl;

  /// No description provided for @backendUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Edit when the LAN address changes'**
  String get backendUrlHint;

  /// No description provided for @noAnalysesYet.
  ///
  /// In en, this message translates to:
  /// **'No analyses yet'**
  String get noAnalysesYet;

  /// No description provided for @analyzeContractFirst.
  ///
  /// In en, this message translates to:
  /// **'Analyze a contract first'**
  String get analyzeContractFirst;

  /// No description provided for @sources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sources;

  /// No description provided for @clauseSingular.
  ///
  /// In en, this message translates to:
  /// **'clause'**
  String get clauseSingular;

  /// No description provided for @clausePlural.
  ///
  /// In en, this message translates to:
  /// **'clauses'**
  String get clausePlural;

  /// No description provided for @deleteHistoryEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry?'**
  String get deleteHistoryEntry;

  /// No description provided for @deleteHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will remove it from history on this device.'**
  String get deleteHistoryConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @pickFirstContract.
  ///
  /// In en, this message translates to:
  /// **'Pick first contract'**
  String get pickFirstContract;

  /// No description provided for @pickSecondContract.
  ///
  /// In en, this message translates to:
  /// **'Pick second contract'**
  String get pickSecondContract;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// No description provided for @analyzeFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed'**
  String get analyzeFailed;

  /// No description provided for @comparisonFailed.
  ///
  /// In en, this message translates to:
  /// **'Comparison failed'**
  String get comparisonFailed;

  /// No description provided for @chatFailed.
  ///
  /// In en, this message translates to:
  /// **'Chat failed'**
  String get chatFailed;

  /// No description provided for @exportDisabledTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export is not available in this version'**
  String get exportDisabledTooltip;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @pickDifferentFile.
  ///
  /// In en, this message translates to:
  /// **'Pick a different file'**
  String get pickDifferentFile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @backendUrlSaved.
  ///
  /// In en, this message translates to:
  /// **'Backend URL saved'**
  String get backendUrlSaved;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @needsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs Review'**
  String get needsReview;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry?'**
  String get deleteEntry;

  /// No description provided for @deleteEntryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will remove it from history on this device.'**
  String get deleteEntryConfirmation;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @sortedByMostRecent.
  ///
  /// In en, this message translates to:
  /// **'Sorted by most recent'**
  String get sortedByMostRecent;

  /// No description provided for @monitoringActive.
  ///
  /// In en, this message translates to:
  /// **'Monitoring active'**
  String get monitoringActive;

  /// No description provided for @priorityItems.
  ///
  /// In en, this message translates to:
  /// **'Priority items'**
  String get priorityItems;

  /// No description provided for @clausesCount.
  ///
  /// In en, this message translates to:
  /// **'clauses'**
  String get clausesCount;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @noComparisonData.
  ///
  /// In en, this message translates to:
  /// **'No comparison data'**
  String get noComparisonData;

  /// No description provided for @compareTwoContracts.
  ///
  /// In en, this message translates to:
  /// **'Compare two contracts'**
  String get compareTwoContracts;

  /// No description provided for @chatSession.
  ///
  /// In en, this message translates to:
  /// **'Chat Session'**
  String get chatSession;

  /// No description provided for @preparingRag.
  ///
  /// In en, this message translates to:
  /// **'Preparing RAG…'**
  String get preparingRag;

  /// No description provided for @askAiSummarizeNegotiate.
  ///
  /// In en, this message translates to:
  /// **'Ask AI to summarize, compare, or negotiate'**
  String get askAiSummarizeNegotiate;

  /// No description provided for @noActiveChatSession.
  ///
  /// In en, this message translates to:
  /// **'No active chat session'**
  String get noActiveChatSession;

  /// No description provided for @startNewSessionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start a new session to begin chatting with AI'**
  String get startNewSessionPrompt;

  /// No description provided for @startNewSession.
  ///
  /// In en, this message translates to:
  /// **'Start New Session'**
  String get startNewSession;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @askQuestionToStart.
  ///
  /// In en, this message translates to:
  /// **'Ask a question to start'**
  String get askQuestionToStart;

  /// No description provided for @typeQuestionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type your question…'**
  String get typeQuestionPlaceholder;

  /// No description provided for @closeSession.
  ///
  /// In en, this message translates to:
  /// **'Close Session'**
  String get closeSession;

  /// No description provided for @aiSummary.
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get aiSummary;

  /// No description provided for @contractAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Contract Analysis'**
  String get contractAnalysis;

  /// No description provided for @noRecentAnalyses.
  ///
  /// In en, this message translates to:
  /// **'No recent analyses'**
  String get noRecentAnalyses;

  /// No description provided for @analyzeFirstContract.
  ///
  /// In en, this message translates to:
  /// **'Analyze first contract'**
  String get analyzeFirstContract;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will remove all history entries from this device.'**
  String get clearHistoryConfirmation;

  /// No description provided for @unknownVersion.
  ///
  /// In en, this message translates to:
  /// **'Unknown version'**
  String get unknownVersion;

  /// No description provided for @aiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendations'**
  String get aiRecommendations;

  /// No description provided for @suggestedEditsRationale.
  ///
  /// In en, this message translates to:
  /// **'Suggested edits & rationale'**
  String get suggestedEditsRationale;

  /// No description provided for @needsAction.
  ///
  /// In en, this message translates to:
  /// **'Needs Action'**
  String get needsAction;

  /// No description provided for @inContract1.
  ///
  /// In en, this message translates to:
  /// **'In contract 1'**
  String get inContract1;

  /// No description provided for @inContract2.
  ///
  /// In en, this message translates to:
  /// **'In contract 2'**
  String get inContract2;

  /// No description provided for @noSignificantDifferences.
  ///
  /// In en, this message translates to:
  /// **'No significant differences found'**
  String get noSignificantDifferences;

  /// No description provided for @clauseDifferencesAiSummary.
  ///
  /// In en, this message translates to:
  /// **'Clause differences — AI summary'**
  String get clauseDifferencesAiSummary;

  /// No description provided for @aiSummarizedDeltas.
  ///
  /// In en, this message translates to:
  /// **'AI-summarized deltas'**
  String get aiSummarizedDeltas;

  /// No description provided for @uploadContract.
  ///
  /// In en, this message translates to:
  /// **'Upload Contract'**
  String get uploadContract;

  /// No description provided for @compareVersions.
  ///
  /// In en, this message translates to:
  /// **'Compare Versions'**
  String get compareVersions;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @summaryScore.
  ///
  /// In en, this message translates to:
  /// **'Summary Score'**
  String get summaryScore;

  /// No description provided for @aiConfidenceRiskPosture.
  ///
  /// In en, this message translates to:
  /// **'AI confidence & risk posture'**
  String get aiConfidenceRiskPosture;

  /// No description provided for @overallCompliance.
  ///
  /// In en, this message translates to:
  /// **'Overall Compliance'**
  String get overallCompliance;

  /// No description provided for @criticalIssues.
  ///
  /// In en, this message translates to:
  /// **'Critical Issues'**
  String get criticalIssues;

  /// No description provided for @negotiableClauses.
  ///
  /// In en, this message translates to:
  /// **'Negotiable Clauses'**
  String get negotiableClauses;

  /// No description provided for @shareHighRiskWithCounsel.
  ///
  /// In en, this message translates to:
  /// **'Share high-risk items with counsel'**
  String get shareHighRiskWithCounsel;

  /// No description provided for @requestRedlinesForHighRisk.
  ///
  /// In en, this message translates to:
  /// **'Request redlines for high-risk clauses'**
  String get requestRedlinesForHighRisk;

  /// No description provided for @scheduleFollowUpAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Schedule follow-up analysis'**
  String get scheduleFollowUpAnalysis;

  /// No description provided for @reviewKeyRisks.
  ///
  /// In en, this message translates to:
  /// **'Review {count} key risks'**
  String reviewKeyRisks(Object count);

  /// No description provided for @keyFindings.
  ///
  /// In en, this message translates to:
  /// **'Key Findings'**
  String get keyFindings;

  /// No description provided for @highestImpactClauses.
  ///
  /// In en, this message translates to:
  /// **'Highest impact clauses'**
  String get highestImpactClauses;

  /// No description provided for @suggestedNextSteps.
  ///
  /// In en, this message translates to:
  /// **'Suggested next steps'**
  String get suggestedNextSteps;

  /// No description provided for @noAnalysisData.
  ///
  /// In en, this message translates to:
  /// **'No analysis data available'**
  String get noAnalysisData;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @contractComparison.
  ///
  /// In en, this message translates to:
  /// **'Contract Comparison'**
  String get contractComparison;

  /// No description provided for @clauseDetails.
  ///
  /// In en, this message translates to:
  /// **'Clause Details'**
  String get clauseDetails;

  /// No description provided for @noClauseData.
  ///
  /// In en, this message translates to:
  /// **'No clause data available'**
  String get noClauseData;

  /// No description provided for @recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendation;

  /// No description provided for @clause.
  ///
  /// In en, this message translates to:
  /// **'clause'**
  String get clause;

  /// No description provided for @complianceScore.
  ///
  /// In en, this message translates to:
  /// **'Compliance Score'**
  String get complianceScore;

  /// No description provided for @highRisk.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get highRisk;

  /// No description provided for @mediumRisk.
  ///
  /// In en, this message translates to:
  /// **'Medium Risk'**
  String get mediumRisk;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
