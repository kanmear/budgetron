import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/colors.dart';

//TODO clean up extra class
class BudgetronLargeTextButton extends StatelessWidget {
  final List<Listenable> listenables;
  final Function isActive;
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
    required this.isActive,
    required this.listenables,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            visualDensity: VisualDensity.compact),
        onPressed: () => _resolveAction(),
        child: AnimatedBuilder(
          animation: Listenable.merge(listenables),
          builder: (BuildContext context, Widget? child) {
            Color buttonColor = _resolveColor();

            return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 13.5,
                  bottom: 13.5,
                ),
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border(
                        top: BorderSide(color: buttonColor),
                        bottom: BorderSide(color: buttonColor),
                        left: BorderSide(color: buttonColor),
                        right: BorderSide(color: buttonColor))),
                child: Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ));
          },
        ));
  }

  _resolveAction() => isActive() ? onTap() : {};

  Color _resolveColor() => isActive() ? backgroundColor : BudgetronColors.gray0;
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
