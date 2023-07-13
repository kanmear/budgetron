import 'package:flutter/material.dart';

class BudgetronColors {
  static const Color black = Color(0xff322e37);
  static const Color gray4 = Color(0xffbdbdbd);
  static const Color gray0 = Color(0xffe0e0e0);

  static const Color background = Color(0xfff7f7f7);
  static const Color backgroundHalfOpacity = Color(0x80f7f7f7);
  static const Color surface = Color(0xffffffff);

  static const Color mainGreen = Color(0xff9fd356);

  static ColorScheme budgetronColorScheme = const ColorScheme(
    primary: BudgetronColors.black,
    onPrimary: Colors.white,
    secondary: BudgetronColors.mainGreen,
    onSecondary: Colors.white,
    background: BudgetronColors.background,
    onBackground: Colors.black,
    surface: BudgetronColors.surface,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    brightness: Brightness.light,
  );
}
