import 'package:flutter/material.dart';

class BudgetronSelectButton extends StatelessWidget {
  final Function onTap;
  final Text text;

  const BudgetronSelectButton(
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
                    width: 1.5, color: Theme.of(context).colorScheme.primary)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text,
                  Icon(Icons.arrow_right,
                      color: Theme.of(context).colorScheme.primary)
                ])));
  }
}
