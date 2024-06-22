import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/utils/interfaces.dart';

class EntryValueInputField extends StatelessWidget {
  final ValueNotifier<TabValue> tabNotifier;
  final TextEditingController textController;

  const EntryValueInputField({
    super.key,
    required this.tabNotifier,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppData>(context).currency;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: tabNotifier,
                builder: (context, value, _) {
                  return Text(_resolveLeading(),
                      style: BudgetronFonts.robotoSize32Weight400);
                }),
            IntrinsicWidth(
                child: ValueTextField(textController: textController)),
            const SizedBox(width: 8),
            Text(currency, style: BudgetronFonts.robotoSize32Weight400),
            ValueListenableBuilder(
                valueListenable: tabNotifier,
                builder: (context, value, _) {
                  return _resolveTrailing(context);
                }),
          ],
        ),
      ),
    );
  }

  String _resolveLeading() => tabNotifier.value.getValue() ? '' : '–';

  Widget _resolveTrailing(BuildContext context) {
    return tabNotifier.value.getValue()
        ? const SizedBox()
        : Text('–',
            style: BudgetronFonts.robotoSize32Weight400
                .apply(color: Theme.of(context).colorScheme.background));
  }
}

class ValueTextField extends StatefulWidget {
  final TextEditingController textController;

  const ValueTextField({super.key, required this.textController});

  @override
  State<ValueTextField> createState() => _ValueTextFieldState();
}

class _ValueTextFieldState extends State<ValueTextField> {
  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_onChanged);
  }

  @override
  void dispose() {
    super.dispose();
    widget.textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.end,
      readOnly: true,
      showCursor: false,
      controller: widget.textController,
      autofocus: true,
      keyboardType: TextInputType.number,
      style: BudgetronFonts.robotoSize32Weight400,
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintStyle: BudgetronFonts.robotoSize32Weight400Hint,
      ),
    );
  }

  void _onChanged() {
    //TODO test interactions with keyboard
    String value = widget.textController.text;
    if (value.length != 1 && value.startsWith('0') && !value.contains('.')) {
      widget.textController.text = value.substring(1);
    } else if (value.isEmpty) {
      //FIX sometimes does not work
      widget.textController.text = '0';
    } else if (double.tryParse(value) == 0 && !value.contains('.')) {
      widget.textController.text = '0';
    }
  }
}
