import 'package:flutter/material.dart';

class BudgetronCheckbox extends StatelessWidget {
  const BudgetronCheckbox({super.key, required this.valueNotifier});

  final ValueNotifier<bool> valueNotifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 20,
        height: 20,
        child: ValueListenableBuilder(
            valueListenable: valueNotifier,
            builder: (BuildContext context, value, Widget? child) {
              return Checkbox(
                  value: value,
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(
                      (states) => Theme.of(context).colorScheme.outlineVariant),
                  onChanged: (bool? value) => _onChanged(value!),
                  side: BorderSide.none);
            }));
  }

  void _onChanged(bool value) {
    valueNotifier.value = value;
  }
}
