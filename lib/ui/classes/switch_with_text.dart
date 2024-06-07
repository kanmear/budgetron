import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';

class BudgetronSwitchWithText extends StatefulWidget {
  final ValueNotifier<bool> switchNotifier;
  final String text;

  const BudgetronSwitchWithText(
      {super.key, required this.switchNotifier, required this.text});

  @override
  State<BudgetronSwitchWithText> createState() =>
      _BudgetronSwitchWithTextState();
}

class _BudgetronSwitchWithTextState extends State<BudgetronSwitchWithText> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surface),
        height: 58,
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(widget.text, style: BudgetronFonts.nunitoSize14Weight400),
          Switch(
              onChanged: (bool value) =>
                  setState(() => widget.switchNotifier.value = value),
              value: widget.switchNotifier.value,
              activeColor: Theme.of(context).colorScheme.secondary)
        ]));
  }
}
