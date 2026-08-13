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

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Intelligent Contract Analysis'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'تحليل العقود بذكاء'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Use AI to understand and analyze legal contracts with precision and speed. Extract key terms and identify potential risks in seconds.'**
  String get onboardingDescription1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Insights'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'رؤى مدعومة بالذكاء الاصطناعي'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Get instant insights on contract clauses, risks, and compliance. Our AI analyzes contracts like a senior legal expert.'**
  String get onboardingDescription2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Multi-Language Support'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'دعم متعدد اللغات'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Analyze contracts in multiple languages with automatic translation and comparison capabilities.'**
  String get onboardingDescription3;

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

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

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
