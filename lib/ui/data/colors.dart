import 'package:flutter/material.dart';

class BudgetronColors {
  static const Color lightSurface0 = Color(0xffF1F1F1);
  static const Color lightSurface1 = Color(0xffFFFFFF);
  static const Color lightSurface2 = Color(0xffE4E4E4);
  static const Color lightSurface3 = Color(0xffD7D7D7);
  static const Color lightSurface4 = Color(0xffCBCBCB);

  static const Color lightPrimary = Color(0xff232323);
  static const Color lightSecondary = Color(0xffCDDC39);

  static const Color darkSurface0 = Color(0xff232323);
  static const Color darkSurface1 = Color(0xff313131);
  static const Color darkSurface2 = Color(0xff3E3E3E);
  static const Color darkSurface3 = Color(0xff4B4B4B);
  static const Color darkSurface4 = Color(0xff575757);

  static const Color darkPrimary = Color(0xffFFFFFF);
  static const Color darkSecondary = Color(0xffE6EE9C);

  static const Color buttonText = Color(0xff232323);
  static const Color tertiary = Color(0xffB39DDB);
  static const Color error = Color(0xffFFAB91);
  static const Color white = Color(0xffFFFFFF);

  static ColorScheme lightColorScheme = const ColorScheme(
    primary: lightPrimary,
    //NOTE onPrimary is what text buttons use
    onPrimary: buttonText,
    secondary: lightSecondary,
    onSecondary: buttonText,
    tertiary: tertiary,
    surface: lightSurface0,
    onSurface: lightPrimary,
    surfaceContainerLowest: lightSurface1,
    surfaceContainerLow: lightSurface2,
    surfaceContainer: lightSurface3,
    surfaceContainerHigh: lightSurface4,
    //NOTE tint is used as a crutch for additional color complements
    surfaceTint: lightSurface0,
    error: error,
    onError: buttonText,
    brightness: Brightness.light,
  );

  static ColorScheme darkColorScheme = const ColorScheme(
    primary: darkPrimary,
    onPrimary: buttonText,
    secondary: darkSecondary,
    onSecondary: buttonText,
    tertiary: tertiary,
    surface: darkSurface0,
    onSurface: darkPrimary,
    surfaceContainerLowest: darkSurface1,
    surfaceContainerLow: darkSurface2,
    surfaceContainer: darkSurface3,
    surfaceContainerHigh: darkSurface4,
    surfaceTint: darkSurface0,
    error: error,
    onError: buttonText,
    brightness: Brightness.light,
  );
}
