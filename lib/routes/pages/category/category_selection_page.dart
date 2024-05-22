import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/ui/classes/tab_switch.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/popups/category/new_category_popup.dart';

class CategorySelectionPage extends StatelessWidget {
  CategorySelectionPage({
    super.key,
    required this.isMultipleSelection,
    required this.categoryTypeNotifier,
  });

  final ValueNotifier<EntryCategoryType> categoryTypeNotifier;
  //REFACTOR can be made const by throwing out initialization of nameFilter
  final ValueNotifier<String> nameFilter = ValueNotifier('');

  final bool isMultipleSelection;

  @override
  Widget build(BuildContext context) {
    var title = isMultipleSelection ? 'Choose categories' : 'Choose category';

    return Scaffold(
        appBar:
            BudgetronAppBar(leading: const ArrowBackIconButton(), title: title),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(children: [
          //TODO move to appbar
          // BudgetronSearchField(
          //     hintText: "Search for a category", filter: nameFilter),
          BudgetronTabSwitch(
              valueNotifier: categoryTypeNotifier,
              tabs: const [EntryCategoryType.expense, EntryCategoryType.income],
              getTabName: (value) => value.toString()),
          const SizedBox(height: 24),
          CategoriesList(
              nameFilter: nameFilter,
              categoryTypeNotifier: categoryTypeNotifier)
        ]),
        floatingActionButton: BudgetronFloatingActionButtonWithPlus(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => NewCategoryDialog(
                    entryCategoryType: categoryTypeNotifier.value))));
  }
}

class CategoriesList extends StatelessWidget {
  final ValueNotifier<EntryCategoryType> categoryTypeNotifier;
  final ValueNotifier<String> nameFilter;

  const CategoriesList({
    super.key,
    required this.nameFilter,
    required this.categoryTypeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: categoryTypeNotifier,
        builder:
            (BuildContext context, EntryCategoryType value, Widget? child) {
          return StreamBuilder<List<EntryCategory>>(
              stream: CategoryController.getCategories('', value),
              builder: (context, snapshot) {
                if (snapshot.data?.isNotEmpty ?? false) {
                  List<EntryCategory> categories = snapshot.data!;
                  categories.sort((a, b) => b.usages.compareTo(a.usages));

                  return ValueListenableBuilder(
                      valueListenable: nameFilter,
                      builder: (context, value, child) {
                        return ListView(padding: EdgeInsets.zero, children: [
                          for (var category in categories)
                            if (category.name
                                .toLowerCase()
                                .contains(nameFilter.value.toLowerCase()))
                              _categoryListTile(category, context)
                        ]);
                      });
                } else {
                  return Center(
                    child: Text("No categories in database",
                        style: BudgetronFonts.nunitoSize16Weight300Gray),
                  );
                }
              });
        },
      ),
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
