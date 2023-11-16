import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';

class BudgetronDrawer extends StatelessWidget {
  const BudgetronDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SafeArea(
                child: Row(
              children: [
                Text('Budgetron ', style: BudgetronFonts.nunitoSize18Weight600),
                Text('v0.9', style: BudgetronFonts.nunitoSize18Weight600Gray),
              ],
            )),
            const SizedBox(height: 8),
            const DrawerEntries()
          ],
        ),
      ),
    );
  }
}

class DrawerEntries extends StatelessWidget {
  const DrawerEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
            onTap: () => _navigateToCategoriesPage(context),
            child: Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Categories',
                  textAlign: TextAlign.start,
                  style: BudgetronFonts.nunitoSize16Weight600),
            ))
      ],
    );
  }

  void _navigateToCategoriesPage(BuildContext context) {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => CategoriesPage()));
  }
}
