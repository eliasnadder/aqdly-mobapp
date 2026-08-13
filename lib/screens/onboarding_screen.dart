import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import 'home_dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Onboarding pages data
  final List<Map<String, String>> _onboardingPages = [
    {
      'title': 'Intelligent Contract Analysis',
      'subtitle': 'تحليل العقود بذكاء',
      'description':
          'Use AI to understand and analyze legal contracts with precision and speed. Extract key terms and identify potential risks in seconds.',
      'description_ar':
          'استخدم قوة الذكاء الاصطناعي لفهم وتحليل العقود القانونية بدقة وسرعة. استخرج الشروط الأساسية، وحدد المخاطر المحتملة في ثوانٍ.',
      'icon': 'document_scanner',
    },
    {
      'title': 'AI-Powered Insights',
      'subtitle': 'رؤى مدعومة بالذكاء الاصطناعي',
      'description':
          'Get instant insights on contract clauses, risks, and compliance. Our AI analyzes contracts like a senior legal expert.',
      'description_ar':
          'احصل على رؤى فورية حول بنود العقود والمخاطر والامتثال. يقوم ذكاءنا الاصطناعي بتحليل العقود مثل خبير قانوني مخضرم.',
      'icon': 'insights',
    },
    {
      'title': 'Multi-Language Support',
      'subtitle': 'دعم متعدد اللغات',
      'description':
          'Analyze contracts in multiple languages with automatic translation and comparison capabilities.',
      'description_ar':
          'قم بتحليل العقود بعدة لغات مع قدرات الترجمة والمقارنة التلقائية.',
      'icon': 'language',
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeDashboardScreen()),
    );
  }

  Future<void> _skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeDashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isArabic = l10n.localeName == 'ar';

    return Scaffold(
      body: Stack(
        children: [
          // Background with animated blobs effect
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.darkBackground, AppColors.darkSurface],
              ),
            ),
          ),

          // Animated background blobs (simplified with containers)
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withAlpha(51), // 20% opacity
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withAlpha(
                  51,
                ), // 20% opacity
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top app bar with skip button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _skipOnboarding,
                        child: Text(
                          isArabic
                              ? '${l10n.skip}\nSkip'
                              : 'Skip\n${l10n.skip}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(Icons.gavel, color: AppColors.primary, size: 32),
                    ],
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    children: _onboardingPages.map((page) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Hero graphic
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(
                                  51,
                                ), // 20% opacity
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primaryFixedDim
                                          .withAlpha(77), // 30% opacity
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    _getIconData(page['icon']!),
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Title
                            Text(
                              isArabic ? page['subtitle']! : page['title']!,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              isArabic ? page['title']! : page['subtitle']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurfaceVariant,
                                letterSpacing: 1.5,
                                height: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Description
                            Text(
                              isArabic
                                  ? page['description_ar']!
                                  : page['description']!,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.onSurfaceVariant,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Page indicators
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _onboardingPages.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? AppColors.primary
                                        : AppColors.surfaceVariant,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Bottom action button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _onboardingPages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.next,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isRtl ? Icons.arrow_back : Icons.arrow_forward,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'document_scanner':
        return Icons.document_scanner_outlined;
      case 'insights':
        return Icons.insights_outlined;
      case 'language':
        return Icons.language_outlined;
      default:
        return Icons.document_scanner_outlined;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
