part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class LoadThemeMode extends ThemeEvent {
  const LoadThemeMode();
}

class ChangeThemeMode extends ThemeEvent {
  final ThemeMode themeMode;

  const ChangeThemeMode(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}
