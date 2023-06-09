import 'package:flutter/material.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/popups/new_category_popup.dart';
import 'package:budgetron/ui/classes/top_bar_with_tabs.dart';

class CategoriesPage extends StatelessWidget {
  final filter = ValueNotifier("");
  final EntryCreationTabs typeFilter;

  CategoriesPage({
    super.key,
    required this.typeFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search',
                prefixIcon: Icon(Icons.search)),
            onChanged: (value) => {filter.value = value},
          ),
          CategoriesList(
            valueNotifier: filter,
            typeFilter: typeFilter,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => const NewCategoryDialog()),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text('Categories')),
    );
  }
}

class CategoriesList extends StatelessWidget {
  final ValueNotifier<String> valueNotifier;
  final EntryCreationTabs typeFilter;

  const CategoriesList({
    super.key,
    required this.valueNotifier,
    required this.typeFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<EntryCategory>>(
          stream: objectBox.getCategories("", typeFilter),
          builder: (context, snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              return ValueListenableBuilder(
                  valueListenable: valueNotifier,
                  builder: (context, value, child) {
                    return ListView(
                      children: [
                        for (var category in snapshot.data!)
                          if (category.name
                              .toLowerCase()
                              .contains(valueNotifier.value.toLowerCase()))
                            Card(
                                child: ListTile(
                                    leading: category.isExpense
                                        ? const Icon(Icons.money_off)
                                        : const Icon(Icons.money),
                                    title: Text(category.name),
                                    onTap: () => _selectCategoryAndReturn(
                                        category, context)))
                      ],
                    );
                  });
            } else {
              return const Center(
                child: Text("No categories in database"),
              );
            }
          }),
    );
  }

  void _selectCategoryAndReturn(EntryCategory category, BuildContext context) {
    Navigator.pop(context, category);
  }
}
