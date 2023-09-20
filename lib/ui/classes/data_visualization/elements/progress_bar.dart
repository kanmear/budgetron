import 'package:flutter/material.dart';

class BudgetronProgressBar extends StatelessWidget {
  const BudgetronProgressBar({
    super.key,
    required this.currentValue,
    required this.totalValue,
  });

  final double currentValue;
  final double totalValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2),
      child: Container(
        height: 4,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2))),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        child: LinearProgressIndicator(
            value: currentValue / totalValue,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.background),
      ),
    );
  }
}
