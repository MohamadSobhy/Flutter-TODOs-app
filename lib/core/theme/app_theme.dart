import 'package:flutter/material.dart';

enum AppTheme {
  purpleDark,
  purpleLight,
  greenDark,
  greenLight,
}

final appThemesData = {
  AppTheme.purpleDark: ThemeData.dark().copyWith(
    primaryColor: Colors.purple[700],
    accentColor: Color(0xFF845EC2),
  ),
  AppTheme.purpleLight: ThemeData.light().copyWith(
    primaryColor: Colors.purple,
    accentColor: Color(0xFF845EC2),
  ),
  AppTheme.greenDark: ThemeData.dark().copyWith(
    primaryColor: Colors.green[700],
    accentColor: Color(0xFF79B791),
  ),
  AppTheme.greenLight: ThemeData.light().copyWith(
    primaryColor: Colors.green,
    accentColor: Color(0xFF79B791),
  ),
};
