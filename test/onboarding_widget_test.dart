import 'package:app_v1/app_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'AppWrapper shows Google auth when the user is not authenticated',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({
        'onboarding_completed': false,
        'user_authenticated': false,
      });

      await tester.pumpWidget(const AppWrapper());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Continue with Google'), findsOneWidget);
    },
  );

  testWidgets('Authenticated user sees onboarding before dashboard route', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    SharedPreferences.setMockInitialValues({
      'onboarding_completed': false,
      'user_authenticated': true,
    });

    await tester.pumpWidget(const AppWrapper());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Intelligent Contract Analysis'), findsOneWidget);
  });
}
