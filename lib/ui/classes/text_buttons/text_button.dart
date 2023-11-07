import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/colors.dart';

//REFACTOR small button should have 8 padding
class BudgetronLargeTextButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;

  const BudgetronLargeTextButton({
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
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 13.5,
              bottom: 13.5,
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

class BudgetronBigTextButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;

  const BudgetronBigTextButton({
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
        child: Row(
          children: [
            Expanded(
              child: Container(
                  constraints: const BoxConstraints(minWidth: 126),
                  padding: const EdgeInsets.only(
                    top: 13.5,
                    bottom: 13.5,
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
                  )),
            ),
          ],
        ));
  }
}
