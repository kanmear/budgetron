import 'package:flutter/material.dart';

class BudgetronColors {
  static const Color black = Color(0xff322e37);
  static const Color gray4 = Color(0xffbdbdbd);
  static const Color gray0 = Color(0xffe0e0e0);

  static const Color background = Color(0xfff5f5f5);
  static const Color surface = Color(0xffffffff);

  static ColorScheme budgetronColorScheme = const ColorScheme(
    primary: BudgetronColors.black,
    onPrimary: Colors.white,
    secondary: Colors.blue,
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
