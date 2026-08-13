import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial()) {
    on<LoadThemeMode>(_onLoadThemeMode);
    on<ChangeThemeMode>(_onChangeThemeMode);
  }

  static const _prefsKey = 'theme_mode';

  Future<void> _onLoadThemeMode(
    LoadThemeMode event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    emit(ThemeChanged(_parseThemeMode(stored)));
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeMode event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, event.themeMode.name);
    emit(ThemeChanged(event.themeMode));
  }

  static ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
