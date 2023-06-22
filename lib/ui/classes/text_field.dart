import 'package:flutter/material.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';

class BudgetronTextField extends StatelessWidget {
  final Function onSubmitted;
  final String hintText;
  final bool autoFocus;

  const BudgetronTextField(
      {super.key,
      required this.hintText,
      required this.autoFocus,
      required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) => onSubmitted(value),
      autofocus: autoFocus,
      style: BudgetronFonts.nunitoSize14Weight400,
      cursorColor: BudgetronColors.black,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.only(top: 9, bottom: 10, left: 8, right: 8),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        hintText: hintText,
        hintStyle: BudgetronFonts.nunitoSize14Weight400Hint,
      ),
    );
  }
}
