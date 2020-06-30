import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme {
  purpleDark,
  purpleLight,
  greenDark,
  greenLight,
}

final appThemesData = {
  AppTheme.purpleDark: ThemeData(
    primaryColor: Colors.purple[700],
    accentColor: Color(0xFF845EC2),
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.aBeeZee().fontFamily,
  ),
  AppTheme.purpleLight: ThemeData(
    primaryColor: Colors.purple,
    accentColor: Color(0xFF845EC2),
    brightness: Brightness.light,
    fontFamily: GoogleFonts.aBeeZee().fontFamily,
  ),
  AppTheme.greenDark: ThemeData(
    primaryColor: Colors.green[700],
    accentColor: Color(0xFF79B791),
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.aBeeZee().fontFamily,
  ),
  AppTheme.greenLight: ThemeData(
    primaryColor: Colors.green,
    accentColor: Color(0xFF79B791),
    brightness: Brightness.light,
    fontFamily: GoogleFonts.aBeeZee().fontFamily,
  ),
};
