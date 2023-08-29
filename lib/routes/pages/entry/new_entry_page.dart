import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/ui/fonts.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/budgetron_ui.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/top_bar_with_tabs.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/routes/pages/category/category_selection_page.dart';

class NewEntryPage extends StatefulWidget {
  //TODO maybe tab should be saved between entries
  final ValueNotifier<EntryCategoryType> tabNotifier =
      ValueNotifier(EntryCategoryType.expense);
  final ValueNotifier<EntryCategory?> categoryNotifier = ValueNotifier(null);

  NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            BudgetronAppBarWithTabs(
              tabNotifier: widget.tabNotifier,
              tabs: Row(
                children: [
                  BudgetronTopBarTab(
                    tabNotifier: widget.tabNotifier,
                    onTapAction: () =>
                        {widget.tabNotifier.value = EntryCategoryType.expense},
                    padding: BudgetronUI.leftTabInAppBar(),
                    name: 'Expense',
                    associatedTabValue: EntryCategoryType.expense,
                  ),
                  BudgetronTopBarTab(
                    tabNotifier: widget.tabNotifier,
                    onTapAction: () =>
                        {widget.tabNotifier.value = EntryCategoryType.income},
                    padding: BudgetronUI.rightTabInAppBar(),
                    name: 'Income',
                    associatedTabValue: EntryCategoryType.income,
                  ),
                ],
              ),
            ),
            EntryValueTextField(
              tabNotifier: widget.tabNotifier,
              categoryNotifier: widget.categoryNotifier,
            ),
            DateAndCategoryRow(
              setCategoryCallback: (value) => setState(() {
                widget.categoryNotifier.value = value;
              }),
              categoryNotifier: widget.categoryNotifier,
              tabNotifier: widget.tabNotifier,
            )
          ],
        ));
  }
}

class DateAndCategoryRow extends StatelessWidget {
  final ValueNotifier<EntryCategoryType> tabNotifier;
  final ValueNotifier<EntryCategory?> categoryNotifier;
  final Function setCategoryCallback;

  const DateAndCategoryRow({
    super.key,
    required this.setCategoryCallback,
    required this.categoryNotifier,
    required this.tabNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DateField(),
        Container(
          //HACK custom divider; check that this height works for all screens
          height: 47,
          width: 1,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 1)),
        ),
        CategoryField(
          setCategoryCallback: setCategoryCallback,
          categoryNotifier: categoryNotifier,
          tabNotifier: tabNotifier,
        )
      ],
    );
  }
}

class CategoryField extends StatefulWidget {
  final ValueNotifier<EntryCategoryType> tabNotifier;
  final ValueNotifier<EntryCategory?> categoryNotifier;
  final Function setCategoryCallback;

  const CategoryField({
    super.key,
    required this.setCategoryCallback,
    required this.categoryNotifier,
    required this.tabNotifier,
  });

  @override
  State<CategoryField> createState() => _CategoryFieldState();
}

class _CategoryFieldState extends State<CategoryField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: () => _navigateToCategorySelection(
          context, widget.setCategoryCallback, widget.tabNotifier.value),
      child: Padding(
        padding: const EdgeInsets.only(top: 21, bottom: 21),
        child: Center(
            child: Column(
          children: [
            Text("Category", style: BudgetronFonts.nunitoSize14Weight400),
            const SizedBox(height: 6),
            ValueListenableBuilder(
                valueListenable: widget.categoryNotifier,
                builder: (context, value, child) {
                  return widget.categoryNotifier.value == null
                      ? Text(
                          "Choose",
                          style: BudgetronFonts.nunitoSize16Weight600Hint,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.square_rounded,
                                color: CategoryService.stringToColor(
                                    widget.categoryNotifier.value!.color)),
                            const SizedBox(width: 6),
                            Text(
                              widget.categoryNotifier.value!.name,
                              style: BudgetronFonts.nunitoSize16Weight600,
                            ),
                          ],
                        );
                }),
          ],
        )),
      ),
    ));
  }

  Future<void> _navigateToCategorySelection(BuildContext context,
      Function callback, EntryCategoryType typeFilter) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoriesPage(typeFilter: typeFilter)));

    if (!mounted) return;
    callback.call(result);
  }
}

class DateField extends StatelessWidget {
  const DateField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: () => {/* TODO add date selection */},
      child: Padding(
        padding: const EdgeInsets.only(top: 21, bottom: 21),
        child: Center(
            child: Column(
          children: [
            Text(
              "Date",
              style: BudgetronFonts.nunitoSize14Weight400,
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat.yMMMd().format(DateTime.now()),
              style: BudgetronFonts.nunitoSize16Weight600,
            )
          ],
        )),
      ),
    ));
  }
}

class EntryValueTextField extends StatelessWidget {
  final ValueNotifier<EntryCategoryType> tabNotifier;
  final ValueNotifier<EntryCategory?> categoryNotifier;

  const EntryValueTextField({
    super.key,
    required this.tabNotifier,
    required this.categoryNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 36.0, right: 36.0),
          child: TextField(
              style: BudgetronFonts.robotoSize32Weight400,
              onSubmitted: (value) => _validateAndSubmit(value, context),
              onTapOutside: (event) {},
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: BudgetronUI.inputDecoration()),
        ),
      ),
    );
  }

  _validateAndSubmit(String value, BuildContext context) {
    if (value.isEmpty || categoryNotifier.value == null) {
      //TODO add some sort of message for user to fill in value and/or category
      return;
    }

    EntryCategory category = categoryNotifier.value!;
    Entry entry = Entry(value: double.parse(value), dateTime: DateTime.now());

    EntryService.createEntry(entry, category);
    if (category.isBudgetTracked) {
      BudgetService.updateBudgetValue(category.id, value);
    }

    Navigator.pop(context);
  }
}
