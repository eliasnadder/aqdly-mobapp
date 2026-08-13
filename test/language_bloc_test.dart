import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:app_v1/bloc/language/language_bloc.dart';

void main() {
  group('LanguageBloc', () {
    test('initial state is LanguageInitial', () {
      expect(LanguageBloc().state, const LanguageInitial());
    });

    blocTest<LanguageBloc, LanguageState>(
      'emits LanguageChanged when ChangeLanguage is added',
      build: () => LanguageBloc(),
      act: (bloc) => bloc.add(ChangeLanguage(const Locale('ar', 'SA'))),
      expect: () => [
        const LanguageChanged(Locale('ar', 'SA')),
      ],
    );
  });
}