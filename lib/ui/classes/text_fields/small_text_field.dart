import 'package:flutter/material.dart';

//TODO rename to text field
class BudgetronSmallTextField extends StatelessWidget {
  final TextEditingController? textController;
  final TextInputType inputType;
  final Function onSubmitted;
  final String hintText;
  final bool autoFocus;

  const BudgetronSmallTextField(
      {super.key,
      required this.hintText,
      required this.autoFocus,
      required this.onSubmitted,
      required this.inputType,
      this.textController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      onSubmitted: (value) => onSubmitted(value),
      controller: textController,
      autofocus: autoFocus,
      keyboardType: inputType,
      style: theme.textTheme.bodyMedium,
      cursorColor: theme.colorScheme.primary,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(8),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: theme.colorScheme.surfaceContainerHigh),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: theme.colorScheme.surfaceContainerHigh, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium!
            .apply(color: theme.colorScheme.surfaceContainerHigh),
      ),
    );
  }
}
