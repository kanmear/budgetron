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

    Map<String, ChartCard> sections = HashMap();
    for (var entry in entries) {
      if (sections.containsKey(entry.section)) {
        sections[entry.section]!.value += entry.value;
      } else {
        sections.addAll({
          entry.section.target!.name: ChartCard(entry.value,
              entry.section.target!.isExpense, entry.section.target!.name)
        });
      }
    }

    return ListView(
      children: [
        for (var key in sections.keys)
          Card(
            child: ListTile(
              title: Row(
                children: [
                  Text(sections[key]!.value.toString()),
                  sections[key]!.isExpense
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
