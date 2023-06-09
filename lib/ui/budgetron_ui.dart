import 'package:flutter/material.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';

class BudgetronUI {
  static InputDecoration budgetronInputDecoration() {
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
}
