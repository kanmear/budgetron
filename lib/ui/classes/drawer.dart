import 'package:flutter/material.dart';

import 'package:budgetron/routes/pages/group/group_page.dart';
import 'package:budgetron/routes/pages/account/accounts_page.dart';
import 'package:budgetron/routes/pages/category/category_page.dart';
import 'package:budgetron/routes/pages/settings/settings_page.dart';

//FIX spacing
class BudgetronDrawer extends StatelessWidget {
  const BudgetronDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                Text('Budgetron ', style: theme.textTheme.displayLarge),
                Text('v0.9',
                    style: theme.textTheme.bodyMedium!
                        .apply(color: theme.colorScheme.surfaceContainerHigh)),
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
          iconData: Icons.star,
        ),
        const SizedBox(height: 16),
        DrawerEntryTile(
          name: 'Categories',
          route: CategoriesPage(),
          iconData: Icons.list,
        ),
        const DrawerEntryTile(
          name: 'Groups',
          route: GroupsPage(),
          iconData: Icons.list_alt,
        ),
        const DrawerEntryTile(
            name: 'Accounts',
            route: AccountsPage(),
            iconData: Icons.credit_card_outlined),
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
          iconData: Icons.settings,
        ),
        DrawerEntryTile(
          name: 'Support',
          route: CategoriesPage(),
          iconData: Icons.help,
        ),
        DrawerEntryTile(
          name: 'About',
          route: CategoriesPage(),
          iconData: Icons.people,
        ),
      ],
    );
  }
}

class DrawerEntryTile extends StatelessWidget {
  final String name;
  final IconData iconData;
  final StatelessWidget route;

  const DrawerEntryTile({
    super.key,
    required this.name,
    required this.route,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
        onTap: () => _navigateToRoute(context),
        child: Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: [
              Icon(iconData, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(name,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.bodyMedium),
            ],
          ),
        ));
  }

  void _navigateToRoute(BuildContext context) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => route));
}
