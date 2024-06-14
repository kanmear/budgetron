import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/utils/interfaces.dart';
import 'package:budgetron/logic/category/category_service.dart';

class BudgetronSelectButton extends StatelessWidget {
  final ValueNotifier<Selectable?> valueNotifier;
  final String hintText;
  final Function onTap;

  const BudgetronSelectButton(
      {super.key,
      required this.onTap,
      required this.valueNotifier,
      required this.hintText});

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
                    width: 1, color: Theme.of(context).colorScheme.primary)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectedItem(
                      valueNotifier: valueNotifier, hintText: hintText),
                  Icon(Icons.arrow_right,
                      color: Theme.of(context).colorScheme.primary)
                ])));
  }
}

class SelectedItem extends StatelessWidget {
  final ValueNotifier<Selectable?> valueNotifier;
  final String hintText;

  const SelectedItem(
      {super.key, required this.valueNotifier, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        builder: (context, value, _) {
          if (value == null) {
            return Text(hintText,
                style: BudgetronFonts.nunitoSize16Weight400Hint);
          } else {
            return Row(children: [
              Icon(Icons.square_rounded,
                  size: 18,
                  color: CategoryService.stringToColor(value.getColor())),
              const SizedBox(width: 4),
              Text(value.toString(),
                  style: BudgetronFonts.nunitoSize16Weight400)
            ]);
          }
        });
  }
}
