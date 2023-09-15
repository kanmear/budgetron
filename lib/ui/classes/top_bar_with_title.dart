import 'package:budgetron/ui/data/fonts.dart';
import 'package:flutter/material.dart';

class BudgetronAppBarWithTitle extends StatelessWidget {
  final Widget leftIconButton;
  final Widget? rightIconButton;
  final String title;

  const BudgetronAppBarWithTitle(
      {super.key,
      required this.title,
      required this.leftIconButton,
      this.rightIconButton});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftIconButton,
          Expanded(
            child: Text(
              title,
              style: BudgetronFonts.nunitoSize18Weight600,
            ),
          ),
          if (rightIconButton != null) rightIconButton!
        ],
      ),
    );
  }
}
