import 'package:budgetron/ui/fonts.dart';
import 'package:budgetron/ui/icons.dart';
import 'package:flutter/material.dart';

class BudgetronAppBarWithTitle extends StatelessWidget {
  final Widget iconButton;
  final String title;

  const BudgetronAppBarWithTitle(
      {super.key, required this.title, required this.iconButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      //TODO find universally correct solution for status bar
      padding: const EdgeInsets.only(top: 38.0),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ArrowBackIconButton(),
            Expanded(
              child: Text(
                title,
                style: BudgetronFonts.nunitoSize18Weight600,
              ),
            ),
            iconButton
          ],
        ),
      ),
    );
  }
}
