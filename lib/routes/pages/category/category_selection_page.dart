import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/ui/classes/checkbox.dart';
import 'package:budgetron/ui/classes/tab_switch.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/popups/category/new_category_popup.dart';

class CategorySelectionPage extends StatelessWidget {
  CategorySelectionPage(
      {super.key,
      this.isMultipleSelection = false,
      this.categories,
      required this.categoryTypeNotifier});

  final ValueNotifier<EntryCategoryType> categoryTypeNotifier;
  final bool isMultipleSelection;

  //REFACTOR can be made const by throwing out initialization of these
  final ValueNotifier<String> nameFilter = ValueNotifier('');
  final List<EntryCategory>? categories;

  @override
  Widget build(BuildContext context) {
    var title = "Choose ${isMultipleSelection ? 'categories' : 'category'}";
    List<EntryCategory> selectedCategories = categories ?? [];

    return Scaffold(
        appBar:
            BudgetronAppBar(leading: const ArrowBackIconButton(), title: title),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(children: [
          //TODO move search to appbar
          // BudgetronSearchField(
          //     hintText: "Search for a category", filter: nameFilter),
          BudgetronTabSwitch(
            valueNotifier: categoryTypeNotifier,
            tabs: const [EntryCategoryType.expense, EntryCategoryType.income],
          ),
          const SizedBox(height: 24),
          CategoriesList(
              nameFilter: nameFilter,
              categoryTypeNotifier: categoryTypeNotifier,
              isMultipleSelection: isMultipleSelection,
              selectedCategories: selectedCategories)
        ]),
        floatingActionButton:
            _resolveFloatingButton(context, selectedCategories));
  }

  Widget _resolveFloatingButton(
      BuildContext context, List<EntryCategory> selectedCategories) {
    final theme = Theme.of(context);

    if (isMultipleSelection) {
      return BudgetronFloatingActionButton(
          onPressed: () => {Navigator.pop(context, selectedCategories)},
          icon: Icon(Icons.check, color: theme.colorScheme.primary));
    }
    return BudgetronFloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => NewCategoryDialog(
                categoryTypeNotifier:
                    ValueNotifier(categoryTypeNotifier.value))));
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList(
      {super.key,
      required this.nameFilter,
      required this.categoryTypeNotifier,
      required this.isMultipleSelection,
      required this.selectedCategories});

  final ValueNotifier<EntryCategoryType> categoryTypeNotifier;
  final List<EntryCategory> selectedCategories;
  final ValueNotifier<String> nameFilter;
  final bool isMultipleSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
        child: ValueListenableBuilder(
            valueListenable: categoryTypeNotifier,
            builder: (BuildContext context, EntryCategoryType categoryType,
                Widget? _) {
              return StreamBuilder<List<EntryCategory>>(
                  stream: CategoryController.getCategories('', categoryType),
                  builder: (context, snapshot) {
                    if (snapshot.data?.isNotEmpty ?? false) {
                      List<EntryCategory> categories = snapshot.data!;
                      categories.sort((a, b) => b.usages.compareTo(a.usages));

                      return ValueListenableBuilder(
                          valueListenable: nameFilter,
                          builder: (context, value, child) {
                            return ListView.separated(
                                //FIX checkbox of last tile can't be seen
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                itemBuilder: (BuildContext context, int index) {
                                  return CategoryListTile(
                                      category: categories[index],
                                      isMultipleSelection: isMultipleSelection,
                                      selectedCategories: selectedCategories,
                                      theme: theme);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 8);
                                },
                                itemCount: categories.length);
                          });
                    } else {
                      return Center(
                          child: Text("No categories in database",
                              style: theme.textTheme.bodyMedium!.apply(
                                  color:
                                      theme.colorScheme.surfaceContainerHigh)));
                    }
                  });
            }));
  }
}

class CategoryListTile extends StatelessWidget {
  CategoryListTile(
      {super.key,
      required this.category,
      required this.isMultipleSelection,
      required this.selectedCategories,
      required this.theme});

  final ValueNotifier<bool> valueNotifier = ValueNotifier(false);
  final List<EntryCategory> selectedCategories;
  final EntryCategory category;
  final bool isMultipleSelection;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    valueNotifier.value = selectedCategories.contains(category);

    valueNotifier.addListener(() {
      if (!selectedCategories.contains(category)) {
        selectedCategories.add(category);
      } else {
        selectedCategories.remove(category);
      }
    });

    //FIX hardcoded list tile margins sum value (32)
    //FIX hardcoded edge insets sum value (24)
    //REFACTOR calculate once in the Main
    final listTileWidth = (MediaQuery.of(context).size.width - 32 - 24).floor();
    final leftPartWidth = (listTileWidth / 6 * 5);

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _resolveOnTap(context),
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: theme.colorScheme.surfaceContainerLowest),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: leftPartWidth,
                    child: Row(children: [
                      Container(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(Icons.square_rounded,
                              size: 18,
                              color: CategoryService.stringToColor(
                                  category.color))),
                      Flexible(
                          child: Text(
                        category.name,
                        style: theme.textTheme.bodyMedium,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ))
                    ]),
                  ),
                  _resolveTrailing()
                ])));
  }

  void _resolveOnTap(BuildContext context) {
    if (isMultipleSelection) {
      _checkCategory();
      return;
    }
    _selectCategoryAndReturn(context);
    return;
  }

  void _selectCategoryAndReturn(BuildContext context) {
    Navigator.pop(context, category);
  }

  void _checkCategory() {
    valueNotifier.value = !valueNotifier.value;
  }

  Widget _resolveTrailing() {
    if (isMultipleSelection) {
      //HACK unique key is used to always use 'fresh' checkboxes so that
      //animation doesn't trigger because of Flutter reusing widgets
      return BudgetronCheckbox(key: UniqueKey(), valueNotifier: valueNotifier);
    }
    return const SizedBox();
  }
}
