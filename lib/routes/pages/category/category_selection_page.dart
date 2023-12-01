import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/ui/classes/search_field.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/popups/category/new_category_popup.dart';

class CategorySelectionPage extends StatelessWidget {
  final ValueNotifier<String> nameFilter = ValueNotifier("");
  final EntryCategoryType typeFilter;

  CategorySelectionPage({
    super.key,
    required this.typeFilter,
  });

  @override
  Widget build(BuildContext context) {
    var title = EntryCategoryType.expense == typeFilter
        ? "Expense categories"
        : "Income categories";

    return Scaffold(
        appBar:
            BudgetronAppBar(leading: const ArrowBackIconButton(), title: title),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            BudgetronSearchField(
                hintText: "Search for a category", filter: nameFilter),
            const SizedBox(height: 8),
            CategoriesList(
              nameFilter: nameFilter,
              typeFilter: typeFilter,
            ),
          ],
        ),
        floatingActionButton: BudgetronFloatingActionButtonWithPlus(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) =>
                  NewCategoryDialog(entryCategoryType: typeFilter)),
        ));
  }
}

class CategoriesList extends StatelessWidget {
  final ValueNotifier<String> nameFilter;
  final EntryCategoryType typeFilter;

  const CategoriesList({
    super.key,
    required this.nameFilter,
    required this.typeFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<EntryCategory>>(
          stream: CategoryController.getCategories("", typeFilter),
          builder: (context, snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              List<EntryCategory> categories = snapshot.data!;
              categories.sort((a, b) => b.usages.compareTo(a.usages));

              return ValueListenableBuilder(
                  valueListenable: nameFilter,
                  builder: (context, value, child) {
                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        for (var category in categories)
                          if (category.name
                              .toLowerCase()
                              .contains(nameFilter.value.toLowerCase()))
                            _categoryListTile(category, context)
                      ],
                    );
                  });
            } else {
              return Center(
                child: Text("No categories in database",
                    style: BudgetronFonts.nunitoSize16Weight300Gray),
              );
            }
          }),
    );
  }

  InkWell _categoryListTile(EntryCategory category, BuildContext context) {
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
                    child: Icon(Icons.square_rounded,
                        size: 18,
                        color: CategoryService.stringToColor(category.color)),
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
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outline, width: 1)),
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
