import 'package:flutter/material.dart';

import 'colors.dart';
import 'fonts.dart';

class BudgetronUI {
  static InputDecoration inputDecoration() {
    return InputDecoration(
        //TODO align paddings with design (don't forget line height for font)
        contentPadding:
            const EdgeInsets.only(top: 9, bottom: 9, left: 10, right: 10),
        hintStyle: BudgetronFonts.robotoSize32Weight400Hint,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: BudgetronColors.black, width: 1),
            borderRadius: BorderRadius.all(Radius.zero)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: BudgetronColors.black, width: 1),
            borderRadius: BorderRadius.all(Radius.zero)),
        hintText: 'Enter value');
  }

  static EdgeInsets leftTabInAppBar() {
    return const EdgeInsets.only(left: 24, right: 15, top: 13, bottom: 13);
  }

  static EdgeInsets rightTabInAppBar() {
    return const EdgeInsets.only(left: 15, right: 24, top: 13, bottom: 13);
  }
}
