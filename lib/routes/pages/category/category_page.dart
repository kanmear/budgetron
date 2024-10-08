import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/ui/classes/search_field.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/list_tiles/list_tile.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/popups/category/new_category_popup.dart';
import 'package:budgetron/routes/popups/category/edit_category_popup.dart';

class CategoriesPage extends StatelessWidget {
  final ValueNotifier<String> nameFilter = ValueNotifier("");

  CategoriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: const BudgetronAppBar(
          title: 'Categories',
          leading: ArrowBackIconButton(),
        ),
        backgroundColor: theme.colorScheme.surface,
        body: Column(
          children: [
            BudgetronSearchField(
                hintText: "Search for a category", filter: nameFilter),
            const SizedBox(height: 8),
            CategoriesList(
              nameFilter: nameFilter,
              theme: theme,
            ),
          ],
        ),
        floatingActionButton: BudgetronFloatingActionButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => NewCategoryDialog(
                    categoryTypeNotifier:
                        ValueNotifier(EntryCategoryType.expense)))));
  }
}

class CategoriesList extends StatelessWidget {
  final ValueNotifier<String> nameFilter;
  final ThemeData theme;

  const CategoriesList({
    super.key,
    required this.nameFilter,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<EntryCategory>>(
          stream: CategoryController.getCategories("", null),
          builder: (context, snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              return ValueListenableBuilder(
                  valueListenable: nameFilter,
                  builder: (context, value, child) {
                    List<EntryCategory> categories = snapshot.data!
                        .where((c) =>
                            c.name.toLowerCase().contains(value.toLowerCase()))
                        .toList();

                    categories.sort((a, b) => a.name.compareTo(b.name));

                    return ListView.separated(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      itemBuilder: (context, index) {
                        return _categoryListTile(categories[index], context);
                      },
                      separatorBuilder: (context, _) {
                        return const SizedBox(height: 8);
                      },
                      itemCount: categories.length,
                    );
                  });
            } else {
              return Center(
                child: Text('No categories in database',
                    style: theme.textTheme.bodyMedium!
                        .apply(color: theme.colorScheme.surfaceContainerHigh)),
              );
            }
          }),
    );
  }

  InkWell _categoryListTile(EntryCategory category, BuildContext context) {
    return InkWell(
        onTap: () => _showEditCategoryDialog(category, context),
        child: CustomListTile(
          leadingIcon: _getLeadingIcon(category.color),
          leadingString: category.name,
        ));
  }

  _getLeadingIcon(String color) => Icon(Icons.square_rounded,
      size: 18, color: CategoryService.stringToColor(color));

  void _showEditCategoryDialog(EntryCategory category, BuildContext context) =>
      showDialog(
          context: context,
          builder: (context) => EditCategoryDialog(category: category));
}
