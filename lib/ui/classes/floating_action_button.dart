import 'package:flutter/material.dart';

//REFACTOR remove default Icon
class BudgetronFloatingActionButton extends StatelessWidget {
  final Function onPressed;
  final Icon icon;

  const BudgetronFloatingActionButton(
      {super.key, required this.onPressed, this.icon = const Icon(Icons.add)});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () => onPressed(),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: Transform.scale(scale: 1.5, child: icon),
    );
  }
}
