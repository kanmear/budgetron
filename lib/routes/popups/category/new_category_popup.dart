import 'package:flutter/material.dart';

import 'package:budgetron/routes/popups/category/category_color_selection_popup.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/radio_list_tile.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/data/fonts.dart';

class NewCategoryDialog extends StatefulWidget {
  final EntryCategoryType? entryCategoryType;

  const NewCategoryDialog({
    super.key,
    this.entryCategoryType,
  });

  @override
  State<NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {
  final isExpense = ValueNotifier(false);

  Color categoryColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<EntryCategoryType> categoryTypeNotifier =
        ValueNotifier(widget.entryCategoryType ?? EntryCategoryType.expense);

    return DockedDialog(
        title: "New Category",
        body: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Color and category name",
              style: BudgetronFonts.nunitoSize16Weight400,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const CategoryColorDialog())
                    .then((value) => _setColor(value)),
                child: Container(
                    padding: EdgeInsets.zero,
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5)),
                    child: categoryColor == Colors.white
                        ? const Icon(Icons.add)
                        : null),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BudgetronSmallTextField(
                  inputType: TextInputType.text,
                  hintText: "Enter category name",
                  autoFocus: true,
                  onSubmitted: (value) {
                    //TODO validate that color isn't white (meaning it wasn't selected)
                    CategoryController.addCategory(EntryCategory(
                        name: value.toString().trim(),
                        isExpense: categoryTypeNotifier.value ==
                            EntryCategoryType.expense,
                        color: CategoryService.colorToString(categoryColor)));
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          //HACK there should be a better way to do this
          Transform.translate(
              offset: const Offset(-3.5, 0),
              child: CategoryTypeRadioButtons(
                categoryTypeNotifier: categoryTypeNotifier,
              )),
        ]));
  }

  void _setColor(Color value) {
    setState(() {
      categoryColor = value;
    });
  }
}

class CategoryTypeRadioButtons extends StatefulWidget {
  final ValueNotifier<EntryCategoryType> categoryTypeNotifier;

  const CategoryTypeRadioButtons({
    super.key,
    required this.categoryTypeNotifier,
  });

  @override
  State<CategoryTypeRadioButtons> createState() =>
      _CategoryTypeRadioButtonsState();
}

class _CategoryTypeRadioButtonsState extends State<CategoryTypeRadioButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      BudgetronRadioListTile(
        label: "Expense",
        padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
        value: EntryCategoryType.expense,
        groupValue: widget.categoryTypeNotifier.value,
        onChanged: (value) => {
          setState(() {
            widget.categoryTypeNotifier.value = value!;
          })
        },
      ),
      const SizedBox(width: 10),
      BudgetronRadioListTile(
        label: "Income",
        padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
        value: EntryCategoryType.income,
        groupValue: widget.categoryTypeNotifier.value,
        onChanged: (value) => {
          setState(() {
            widget.categoryTypeNotifier.value = value!;
          })
        },
      ),
    ]);
  }
}
