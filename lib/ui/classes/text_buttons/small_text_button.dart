import 'package:flutter/material.dart';

class BudgetronSmallTextButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color backgroundColor;

  const BudgetronSmallTextButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            visualDensity: VisualDensity.compact),
        onPressed: () => onTap(),
        child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )));
  }
}
