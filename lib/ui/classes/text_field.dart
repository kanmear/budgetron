import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/colors.dart';
import 'package:budgetron/ui/data/fonts.dart';

class BudgetronTextField extends StatelessWidget {
  final TextEditingController? textController;
  final TextInputType inputType;
  final Function onSubmitted;
  final String hintText;
  final bool autoFocus;

  const BudgetronTextField(
      {super.key,
      required this.hintText,
      required this.autoFocus,
      required this.onSubmitted,
      required this.inputType,
      this.textController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) => onSubmitted(value),
      controller: textController,
      autofocus: autoFocus,
      keyboardType: inputType,
      style: BudgetronFonts.nunitoSize16Weight400,
      cursorColor: BudgetronColors.black,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(8),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        hintText: hintText,
        hintStyle: BudgetronFonts.nunitoSize16Weight400Hint,
      ),
    );
  }
}
