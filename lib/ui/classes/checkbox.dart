import 'package:flutter/material.dart';

class BudgetronCheckbox extends StatelessWidget {
  const BudgetronCheckbox({super.key, required this.valueNotifier});

  final ValueNotifier<bool> valueNotifier;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
        width: 20,
        height: 20,
        child: ValueListenableBuilder(
            valueListenable: valueNotifier,
            builder: (BuildContext context, value, Widget? child) {
              return Checkbox(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(3),
                  //     side: WidgetStateBorderSide.resolveWith((states) =>
                  //         BorderSide(width: 1, color: colorScheme.tertiary))),
                  value: value,
                  checkColor: Colors.white,
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    return value
                        ? colorScheme.tertiary
                        : colorScheme.surfaceContainerLow;
                  }),
                  onChanged: (bool? value) => _onChanged(value!),
                  side: BorderSide.none);
            }));
  }

  void _onChanged(bool value) {
    valueNotifier.value = value;
  }
}
