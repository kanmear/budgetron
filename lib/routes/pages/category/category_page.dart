import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/ui/classes/search_field.dart';
import 'package:budgetron/logic/category/category_service.dart';
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
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: const ArrowBackIconButton(),
          leadingWidth: 48,
          title:
              Text('Categories', style: BudgetronFonts.nunitoSize18Weight600),
          titleSpacing: 0,
          toolbarHeight: 48,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            BudgetronSearchField(
                hintText: "Search for a category", filter: nameFilter),
            const SizedBox(height: 8),
            CategoriesList(
              nameFilter: nameFilter,
            ),
          ],
        ),
        floatingActionButton: BudgetronFloatingActionButtonWithPlus(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const NewCategoryDialog()),
        ));
  }
}

class CategoriesList extends StatelessWidget {
  final ValueNotifier<String> nameFilter;

  const CategoriesList({
    super.key,
    required this.nameFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<EntryCategory>>(
          stream: CategoryController.getCategories("", null),
          builder: (context, snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              List<EntryCategory> categories = snapshot.data!;
              categories.sort((a, b) => a.name.compareTo(b.name));

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
                child: Text('No categories in database',
                    style: BudgetronFonts.nunitoSize16Weight300Gray),
              );
            }
          }),
    );
  }

  InkWell _categoryListTile(EntryCategory category, BuildContext context) {
    return InkWell(
      onTap: () => _showEditCategoryDialog(category, context),
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

  void _showEditCategoryDialog(EntryCategory category, BuildContext context) =>
      showDialog(
          context: context,
          builder: (context) => EditCategoryDialog(category: category));
}
