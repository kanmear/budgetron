import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/popups/new_category_popup.dart';
import 'package:budgetron/models/category.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      body: StreamBuilder<List<Category>>(
          stream: objectBox.getCategories(),
          builder: (context, snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              return ListView(
                children: [
                  for (var category in snapshot.data!)
                    Card(
                        child: ListTile(
                            leading: category.isExpense
                                ? const Icon(Icons.money_off)
                                : const Icon(Icons.money),
                            title: Text(category.name),
                            onTap: () => selectCategoryAndReturn(
                                appState, category, context)))
                ],
              );
            } else {
              return const Center(
                child: Text("No categories in database"),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => const NewCategoryDialog()),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text('Categories')),
    );
  }

  selectCategoryAndReturn(
      AppState appState, Category category, BuildContext context) {
    appState.updateCategory(category);
    Navigator.pop(context);
  }
}
