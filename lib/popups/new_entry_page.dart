import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';
import 'package:budgetron/main.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/pages/categories_page.dart';
import 'package:budgetron/ui/budgetron_ui.dart';
import 'package:budgetron/ui/classes/top_bar_with_tabs.dart';

class NewEntryPage extends StatefulWidget {
  //TODO maybe tab should be saved between entries
  final ValueNotifier<EntryCreationTabs> tabNotifier =
      ValueNotifier(EntryCreationTabs.expense);
  final ValueNotifier<EntryCategory?> categoryNotifier = ValueNotifier(null);

  NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        BudgetronAppBarWithTabs(
          tabNotifier: widget.tabNotifier,
          tabs: Row(
            children: [
              BudgetronTopBarTab(
                tabNotifier: widget.tabNotifier,
                onTapAction: () =>
                    {widget.tabNotifier.value = EntryCreationTabs.expense},
                padding: const EdgeInsets.only(
                    left: 24, right: 15, top: 13, bottom: 13),
                name: 'Expense',
                associatedTabValue: EntryCreationTabs.expense,
              ),
              BudgetronTopBarTab(
                tabNotifier: widget.tabNotifier,
                onTapAction: () =>
                    {widget.tabNotifier.value = EntryCreationTabs.income},
                padding: const EdgeInsets.only(
                    left: 15, right: 24, top: 13, bottom: 13),
                name: 'Income',
                associatedTabValue: EntryCreationTabs.income,
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
  final ValueNotifier<EntryCreationTabs> tabNotifier;
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
          height: 47,
          width: 1,
          decoration: BoxDecoration(
              border: Border.all(color: BudgetronColors.black, width: 1)),
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
  final ValueNotifier<EntryCreationTabs> tabNotifier;
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
                          style: BudgetronFonts.nunitoSize16Weight600Unused,
                        )
                      : Text(
                          widget.categoryNotifier.value!.name,
                          style: BudgetronFonts.nunitoSize16Weight600,
                        );
                }),
          ],
        )),
      ),
    ));
  }

  Future<void> _navigateToCategorySelection(BuildContext context,
      Function callback, EntryCreationTabs typeFilter) async {
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
  final ValueNotifier<EntryCreationTabs> tabNotifier;
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
              decoration: BudgetronUI.budgetronInputDecoration()),
        ),
      ),
    );
  }

  _validateAndSubmit(String value, BuildContext context) {
    if (value.isEmpty || categoryNotifier.value == null) {
      //TODO add some sort of message for user to fill in value and/or category
      return;
    }
    int entryValue =
        int.parse(value) * (categoryNotifier.value!.isExpense ? -1 : 1);
    Entry entry = Entry(value: entryValue, dateTime: DateTime.now());
    objectBox.addEntry(entry, categoryNotifier.value!);
    Navigator.pop(context);
  }
}
