import 'package:flutter/material.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';

class BudgetronTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function onSubmitted;
  final String hintText;
  final bool autoFocus;

  const BudgetronTextField(
      {super.key,
      required this.hintText,
      required this.autoFocus,
      required this.controller,
      required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted(),
      autofocus: autoFocus,
      style: BudgetronFonts.nunitoSize14Weight400,
      cursorColor: BudgetronColors.black,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.only(top: 9, bottom: 10, left: 8, right: 8),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: BudgetronColors.black),
            borderRadius: BorderRadius.all(Radius.circular(2))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: BudgetronColors.black, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(2))),
        hintText: hintText,
        hintStyle: BudgetronFonts.nunitoSize14Weight400Hint,
      ),
    );
  }
}
