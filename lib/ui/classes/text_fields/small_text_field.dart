import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:budgetron/utils/string_utils.dart';

//TODO rename to text field
class BudgetronSmallTextField extends StatelessWidget {
  final TextEditingController textController;
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
      required this.textController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isNumberType = inputType == TextInputType.number;
    final onChanged = isNumberType ? _onChanged : (value) => {};

    List<TextInputFormatter> formatters = [];
    if (isNumberType) {
      //allow only numbers and periods
      formatters.add(FilteringTextInputFormatter.allow(RegExp("[0-9.]")));
    } else if (inputType == TextInputType.text) {
      //allow only letters and numbers
      formatters.add(FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")));
    }

    return TextField(
      onChanged: (value) => onChanged(value),
      inputFormatters: formatters,
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

  //deny starting with a period and multiple periods
  void _onChanged(String value) {
    if (value.length == 1 && value == '.') {
      textController.text = StringUtils.emptyString;
    } else if (RegExp(r'^(.*\..*\.)$').hasMatch(value)) {
      textController.text = value.substring(0, value.lastIndexOf('.'));
    }
  }
}
