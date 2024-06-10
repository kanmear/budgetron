import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';

class ButtonWithIcon extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color color;
  final Icon icon;

  const ButtonWithIcon(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.color,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: BudgetronFonts.nunitoSize16Weight400),
            icon
          ],
        ),
      ),
    );
  }
}
