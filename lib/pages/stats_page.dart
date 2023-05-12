import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'package:budgetron/chart_card.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var entries = appState.entries;

    Map<String, ChartCard> categories = HashMap();
    for (var entry in entries) {
      if (categories.containsKey(entry.category)) {
        categories[entry.category]!.value += entry.value;
      } else {
        categories.addAll({
          entry.category.target!.name: ChartCard(entry.value,
              entry.category.target!.isExpense, entry.category.target!.name)
        });
      }
    }

    return ListView(
      children: [
        for (var key in categories.keys)
          Card(
            child: ListTile(
              title: Row(
                children: [
                  Text(categories[key]!.value.toString()),
                  categories[key]!.isExpense
                      ? const Text(
                          " spent on ",
                          style: TextStyle(color: Colors.red),
                        )
                      : const Text(
                          " made on ",
                          style: TextStyle(color: Colors.green),
                        ),
                  Text(key)
                ],
              ),
            ),
          )
      ],
    );
  }
}
