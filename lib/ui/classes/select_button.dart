import 'package:flutter/material.dart';

import 'package:budgetron/utils/interfaces.dart';
import 'package:budgetron/logic/category/category_service.dart';

class BudgetronSelectButton extends StatelessWidget {
  final ValueNotifier<Selectable?> valueNotifier;
  final Widget? defaultValue;
  final String hintText;
  final Function onTap;

  const BudgetronSelectButton(
      {super.key,
      required this.onTap,
      required this.valueNotifier,
      required this.hintText,
      this.defaultValue});

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
                    width: 1,
                    color: Theme.of(context).colorScheme.surfaceContainerHigh)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SelectedItem(
                        valueNotifier: valueNotifier,
                        hintText: hintText,
                        defaultValue: defaultValue),
                  ),
                  Icon(Icons.arrow_right,
                      color: Theme.of(context).colorScheme.primary)
                ])));
  }
}

class SelectedItem extends StatelessWidget {
  final ValueNotifier<Selectable?> valueNotifier;
  final Widget? defaultValue;
  final String hintText;

  const SelectedItem(
      {super.key,
      required this.valueNotifier,
      required this.hintText,
      this.defaultValue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, value, _) {
          if (value == null) {
            if (defaultValue != null) {
              return defaultValue!;
            }

            return Text(hintText,
                style: theme.textTheme.bodyMedium!
                    .apply(color: theme.colorScheme.surfaceContainerHigh));
          } else {
            return Row(children: [
              Icon(Icons.square_rounded,
                  size: 18, color: CategoryService.stringToColor(value.color)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value.toString(),
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                ),
              )
            ]);
          }
        });
  }
}
