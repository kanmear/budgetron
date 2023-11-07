import 'package:flutter/material.dart';

class BudgetronSmallTextButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color borderColor;

  const BudgetronSmallTextButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
    required this.textStyle,
    required this.borderColor,
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
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                border: Border(
                    top: BorderSide(color: borderColor),
                    bottom: BorderSide(color: borderColor),
                    left: BorderSide(color: borderColor),
                    right: BorderSide(color: borderColor))),
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
            )));
  }
}
