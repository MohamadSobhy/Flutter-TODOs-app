import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/core/theme/app_theme.dart';
import 'package:todo_list_app/injection_container.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final initialTheme = servLocator<SharedPreferences>().getInt('theme');

  @override
  ThemeState get initialState => ThemeState(
        themeData: initialTheme == null
            ? appThemesData[AppTheme.purpleLight]
            : appThemesData[AppTheme.values[initialTheme]],
      );

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ChangeAppThemeEvent) {
      //store new theme to preferences
      _storeThemeInPreferences(event.appTheme);
      yield ThemeState(themeData: appThemesData[event.appTheme]);
    }
  }

  void _storeThemeInPreferences(appTheme) {
    servLocator<SharedPreferences>().setInt('theme', appTheme.index);
  }
}
