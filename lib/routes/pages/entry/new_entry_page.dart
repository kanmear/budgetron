import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/data/budgetron_ui.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:budgetron/ui/classes/top_bar_with_tabs.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/classes/keyboard/number_keyboard.dart';
import 'package:budgetron/ui/classes/text_fields/large_text_field.dart';
import 'package:budgetron/routes/pages/category/category_selection_page.dart';
import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';

class NewEntryPage extends StatefulWidget {
  final ValueNotifier<EntryCategoryType> tabNotifier =
      ValueNotifier(EntryCategoryType.expense);
  final ValueNotifier<EntryCategory?> categoryNotifier = ValueNotifier(null);
  final TextEditingController textController = TextEditingController(text: '-');

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
              textController: widget.textController,
            ),
            DateAndCategoryRow(
              setCategoryCallback: (value) => setState(() {
                widget.categoryNotifier.value = value;
              }),
              categoryNotifier: widget.categoryNotifier,
              tabNotifier: widget.tabNotifier,
            ),
            BudgetronNumberKeyboard(
                textController: widget.textController,
                resolveValueSign: _resolveValueSign,
                onConfirmAction: _createNewEntry,
                isSubmitAvailable: _isSubmitAvailable)
          ],
        ));
  }

  bool _resolveValueSign() =>
      widget.tabNotifier.value == EntryCategoryType.expense;

  _createNewEntry(String value) {
    EntryCategory category = widget.categoryNotifier.value!;
    Entry entry = Entry(value: double.parse(value), dateTime: DateTime.now());

    EntryService.createEntry(entry, category);
    if (category.isBudgetTracked) {
      BudgetService.updateBudgetValue(category.id, double.parse(value));
    }
  }

  bool _isSubmitAvailable(NumberKeyboardService keyboardService) {
    return keyboardService.isValueValidForCreation() &&
        widget.categoryNotifier.value != null;
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
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DateField(),
          const VerticalSeparator(),
          CategoryField(
            setCategoryCallback: setCategoryCallback,
            categoryNotifier: categoryNotifier,
            tabNotifier: tabNotifier,
          )
        ],
      ),
    );
  }
}

class VerticalSeparator extends StatelessWidget {
  const VerticalSeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 21, bottom: 21),
      child: Container(
        width: 1,
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 1)),
      ),
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
    _resetCategoryOnTabChange();

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
                      ? SizedBox(
                          height: 24,
                          child: Text(
                            "Choose",
                            style: BudgetronFonts.nunitoSize16Weight600Hint,
                          ),
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

  _resetCategoryOnTabChange() => widget.tabNotifier
      .addListener(() => widget.categoryNotifier.value = null);
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
                    child: Column(children: [
                  Text("Date", style: BudgetronFonts.nunitoSize14Weight400),
                  const SizedBox(height: 6),
                  Text(DateFormat.yMMMd().format(DateTime.now()),
                      style: BudgetronFonts.nunitoSize16Weight600)
                ])))));
  }
}

class EntryValueTextField extends StatelessWidget {
  final ValueNotifier<EntryCategoryType> tabNotifier;
  final TextEditingController textController;

  const EntryValueTextField({
    super.key,
    required this.tabNotifier,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    _setSignOnTabChange();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Center(
            child: BudgetronLargeTextField(
                textController: textController,
                autoFocus: true,
                onSubmitted: () => {},
                inputType: TextInputType.number,
                showCursor: false,
                readOnly: true)),
      ),
    );
  }

  _setSignOnTabChange() {
    tabNotifier.addListener(() {
      if (tabNotifier.value == EntryCategoryType.expense) {
        String text = textController.text;
        textController.text = text.contains('-') ? text : '-$text';
      } else {
        String text = textController.text;
        textController.text = text.contains('-') ? text.substring(1) : text;
      }
    });
  }
}
