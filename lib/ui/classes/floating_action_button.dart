import 'package:flutter/material.dart';

class BudgetronFloatingActionButtonWithPlus extends StatelessWidget {
  final Function onPressed;

  const BudgetronFloatingActionButtonWithPlus({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressed(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Transform.scale(scale: 1.5, child: const Icon(Icons.add)),
    );
  }
}
