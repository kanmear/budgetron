import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    //REFACTOR maybe Row and Container with decorations could be separate
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.surfaceContainerLowest),
        height: 58,
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(widget.text, style: theme.textTheme.bodySmall),
          Switch(
              trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) => Colors.transparent),
              onChanged: (bool value) =>
                  setState(() => widget.switchNotifier.value = value),
              value: widget.switchNotifier.value,
              activeColor: theme.colorScheme.secondary)
        ]));
  }
}
