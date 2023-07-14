import 'package:flutter/material.dart';

class BudgetronSwitch extends StatefulWidget {
  final ValueNotifier<bool> switchNotifier;

  const BudgetronSwitch({super.key, required this.switchNotifier});

  @override
  State<BudgetronSwitch> createState() => _BudgetronSwitchState();
}

class _BudgetronSwitchState extends State<BudgetronSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (bool value) {
        setState(() {
          widget.switchNotifier.value = value;
        });
      },
      value: widget.switchNotifier.value,
      activeColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
