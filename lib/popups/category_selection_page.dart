import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/classes/search_field.dart';
import 'package:budgetron/popups/new_category_popup.dart';
import 'package:budgetron/ui/classes/top_bar_with_tabs.dart';
import 'package:budgetron/ui/classes/top_bar_with_title.dart';

class CategoriesPage extends StatelessWidget {
  final ValueNotifier<String> nameFilter = ValueNotifier("");
  final EntryCreationTabs typeFilter;

  CategoriesPage({
    super.key,
    required this.typeFilter,
  });

  @override
  Widget build(BuildContext context) {
    var title = EntryCreationTabs.expense == typeFilter
        ? "Expense categories"
        : "Income categories";

    return Scaffold(
      body: Column(
        children: [
          BudgetronAppBarWithTitle(title: title),
          const SizedBox(height: 24),
          BudgetronSearchField(
              hintText: "Search for a category", filter: nameFilter),
          const SizedBox(height: 8),
          CategoriesList(
            nameFilter: nameFilter,
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
    );
  }
}

class CategoriesList extends StatelessWidget {
  final ValueNotifier<String> nameFilter;
  final EntryCreationTabs typeFilter;

  const CategoriesList({
    super.key,
    required this.nameFilter,
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
                  valueListenable: nameFilter,
                  builder: (context, value, child) {
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        for (var category in snapshot.data!)
                          if (category.name
                              .toLowerCase()
                              .contains(nameFilter.value.toLowerCase()))
                            categoryListTile(category, context)
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

  InkWell categoryListTile(EntryCategory category, BuildContext context) {
    return InkWell(
      onTap: () => _selectCategoryAndReturn(category, context),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: const Icon(
                      Icons.square_rounded,
                      //TODO add category color
                      color: BudgetronColors.gray4,
                    ),
                  ),
                  Text(
                    category.name,
                    style: BudgetronFonts.nunitoSize16Weight400,
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                  border: Border.all(color: BudgetronColors.gray0, width: 1)),
            ),
          ),
        ],
      ),
    );
  }

  void _selectCategoryAndReturn(EntryCategory category, BuildContext context) {
    Navigator.pop(context, category);
  }
}
