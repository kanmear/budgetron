import 'package:flutter/material.dart';

import 'latest_entries.dart';
import 'micro_overview.dart';
import 'favorite_budgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: const Column(
          children: [
            MicroOverview(),
            SizedBox(height: 32),
            FavoriteBudgets(),
            Spacer(),
            LatestEntries(),
            SizedBox(height: 16),
          ],
        ));
  }
}
