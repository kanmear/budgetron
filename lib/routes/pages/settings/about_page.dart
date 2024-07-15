import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const BudgetronAppBar(
        leading: ArrowBackIconButton(),
        title: 'About',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              children: [
                Text('Team:', style: theme.textTheme.bodyLarge),
                Text('Developer - Roman Makarov',
                    style: theme.textTheme.bodyMedium),
                Text('UX/UI Designer - Anna Bahachenka',
                    style: theme.textTheme.bodyMedium),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Made with ❤️', style: theme.textTheme.bodyLarge),
                Text('Gomel, Belarus', style: theme.textTheme.bodySmall),
                const SizedBox(height: 16)
              ],
            )
          ],
        ),
      ),
    );
  }
}
