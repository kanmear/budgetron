import 'package:budgetron/ui/data/fonts.dart';
import 'package:flutter/material.dart';

class BudgetronSelectButton extends StatelessWidget {
  const BudgetronSelectButton(
      {super.key, required this.hint, required this.onTap});

  final Function onTap;
  final String hint;

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
              Text(hint, style: BudgetronFonts.nunitoSize16Weight400Hint),
              Icon(Icons.arrow_right,
                  color: Theme.of(context).colorScheme.primary)
            ],
          )),
    );
  }
}
