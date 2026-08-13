import 'package:app_v1/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('launches into the Aqdly mobile dashboard shell', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Aqdly'), findsWidgets);
    expect(find.text('Analyze New Contract'), findsOneWidget);
    expect(find.text('Upload'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
  });
}
