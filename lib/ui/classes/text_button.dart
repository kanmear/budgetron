import 'package:flutter/material.dart';

import 'package:budgetron/ui/fonts.dart';
import 'package:budgetron/ui/colors.dart';

class BudgetronTextButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;

  const BudgetronTextButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            visualDensity: VisualDensity.compact),
        onPressed: () => onTap(),
        child: Container(
            width: 126,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                border: const Border(
                    top: BorderSide(color: BudgetronColors.black),
                    bottom: BorderSide(color: BudgetronColors.black),
                    left: BorderSide(color: BudgetronColors.black),
                    right: BorderSide(color: BudgetronColors.black))),
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
            )));
  }
}