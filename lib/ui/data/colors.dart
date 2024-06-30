import 'package:flutter/material.dart';

class BudgetronColors {
  static const Color black = Color(0xff2a2a2a);
  static const Color gray4 = Color(0xffbdbdbd);
  static const Color gray3 = Color(0xff4f4f4f);
  static const Color gray0 = Color(0xffe0e0e0);

  static const Color gray1 = Color(0xffe4e4e4);
  static const Color gray2 = Color(0xffe4e4e4);

  static const Color background = Color(0xfff7f7f7);
  static const Color backgroundHalfOpacity = Color(0x80f7f7f7);
  static const Color surface = Color(0xffffffff);

  static const Color mainGreen = Color(0xffcddc39);
  static const Color error = Color(0xffff5722);

  static ColorScheme budgetronColorScheme = const ColorScheme(
    primary: black,
    onPrimary: Colors.white,
    secondary: mainGreen,
    tertiary: gray3,
    outline: gray0,
    outlineVariant: gray4,
    onSecondary: gray1,
    background: background,
    onBackground: Colors.black,
    surface: surface,
    onSurface: Colors.black,
    error: error,
    onError: Colors.white,
    brightness: Brightness.light,
  );
}
