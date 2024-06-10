import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/routes/pages/group/group_page.dart';
import 'package:budgetron/routes/pages/account/accounts_page.dart';
import 'package:budgetron/routes/pages/category/category_page.dart';
import 'package:budgetron/routes/pages/settings/settings_page.dart';

//FIX spacing
class BudgetronDrawer extends StatelessWidget {
  const BudgetronDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SafeArea(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('Budgetron ', style: BudgetronFonts.nunitoSize32Weight600),
                Text('v0.9', style: BudgetronFonts.nunitoSize16Weight400Gray),
              ],
            )),
            const SizedBox(height: 16),
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
        const DrawerEntryTile(
            name: 'Premium',
            route: SettingsPage(),
            icon: Icon(
              Icons.star,
              color: Colors.pinkAccent,
            )),
        const SizedBox(height: 16),
        DrawerEntryTile(
            name: 'Categories',
            route: CategoriesPage(),
            icon: const Icon(Icons.list)),
        const DrawerEntryTile(
          name: 'Groups',
          route: GroupsPage(),
          icon: Icon(Icons.list_alt),
        ),
        DrawerEntryTile(
            name: 'Accounts',
            route: AccountsPage(),
            icon: const Icon(Icons.credit_card_outlined)),
        const SizedBox(height: 16),
        // DrawerEntryTile(
        //     name: 'Data export',
        //     route: CategoriesPage(),
        //     icon: const Icon(Icons.output)),
        // DrawerEntryTile(
        //     name: 'Backup',
        //     route: CategoriesPage(),
        //     icon: const Icon(Icons.cloud_upload_rounded)),
        // const SizedBox(height: 16),
        const DrawerEntryTile(
            name: 'Settings',
            route: SettingsPage(),
            icon: Icon(Icons.settings)),
        DrawerEntryTile(
            name: 'Support',
            route: CategoriesPage(),
            icon: const Icon(Icons.help)),
        DrawerEntryTile(
            name: 'About',
            route: CategoriesPage(),
            icon: const Icon(Icons.people)),
      ],
    );
  }
}

class DrawerEntryTile extends StatelessWidget {
  const DrawerEntryTile(
      {super.key, required this.name, required this.route, required this.icon});

  final String name;
  final Widget icon;
  final StatelessWidget route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _navigateToRoute(context),
        child: Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 8),
              Text(name,
                  textAlign: TextAlign.start,
                  style: BudgetronFonts.nunitoSize16Weight600),
            ],
          ),
        ));
  }

  void _navigateToRoute(BuildContext context) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => route));
}
