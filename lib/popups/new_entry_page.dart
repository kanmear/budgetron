import 'package:budgetron/ui/button_styles.dart';
import 'package:budgetron/ui/fonts.dart';
import 'package:flutter/material.dart';

class NewEntryPage extends StatelessWidget {
  NewEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: build custom layout based on buttons?
    return Scaffold(
        body: Column(
      children: [pseudoAppBar()],
    ));
  }
}

class pseudoAppBar extends StatelessWidget {
  const pseudoAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new)),
          Row(
            children: [
              TextButton(
                  style: BudgetronButtonStyles.textButtonStyle,
                  onPressed: () => {},
                  child: Text("Income",
                      style: BudgetronFonts.nunitoSize16Weight400)),
              const SizedBox(width: 30),
              TextButton(
                  style: BudgetronButtonStyles.textButtonStyle,
                  onPressed: () => {},
                  child: Text("Spendings",
                      style: BudgetronFonts.nunitoSize16Weight400)),
            ],
          ),
          const SizedBox(width: 48 /* same size as iconButton */),
        ],
      ),
    );
  }
}
