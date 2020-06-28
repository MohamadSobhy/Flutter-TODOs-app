part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ChangeAppThemeEvent extends ThemeEvent {
  final AppTheme appTheme;

  ChangeAppThemeEvent({@required this.appTheme});

  @override
  List<Object> get props => [appTheme];
}
