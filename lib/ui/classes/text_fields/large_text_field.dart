import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/colors.dart';
import 'package:budgetron/ui/data/fonts.dart';

class BudgetronLargeTextField extends StatelessWidget {
  final TextEditingController? textController;
  final TextInputType inputType;
  final Function onSubmitted;
  final String? hintText;
  final bool showCursor;
  final bool autoFocus;
  final bool readOnly;

  const BudgetronLargeTextField(
      {super.key,
      required this.autoFocus,
      required this.onSubmitted,
      required this.inputType,
      required this.showCursor,
      required this.readOnly,
      this.textController,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        readOnly: readOnly,
        showCursor: showCursor,
        onSubmitted: (value) => onSubmitted(value, context),
        controller: textController,
        autofocus: autoFocus,
        keyboardType: inputType,
        style: BudgetronFonts.robotoSize32Weight400,
        cursorColor: BudgetronColors.black,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.only(left: 14, right: 14, top: 7, bottom: 7),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
              borderRadius: const BorderRadius.all(Radius.circular(3))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(3))),
          hintText: hintText,
          hintStyle: BudgetronFonts.robotoSize32Weight400Hint,
        ),
      ),
    );
  }
}
