import 'package:flutter/material.dart';

//REFACTOR move outer part of this widget from (new_group_popup and edit_group_popup) to here
class BudgetronMultiSelectButton extends StatelessWidget {
  final Function onTap;
  final Text text;

  const BudgetronMultiSelectButton(
      {super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(),
        child: Container(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                    width: 1.5,
                    color: Theme.of(context).colorScheme.surfaceContainerLow)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text,
                  Icon(Icons.arrow_right,
                      color: Theme.of(context).colorScheme.primary)
                ])));
  }
}
