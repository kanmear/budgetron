import 'dart:math';

import 'package:budgetron/ui/classes/radio_list_tile.dart';
import 'package:budgetron/ui/classes/text_field.dart';
import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/main.dart';
import 'package:budgetron/models/category.dart';

class NewCategoryDialog extends StatefulWidget {
  const NewCategoryDialog({
    super.key,
  });

  @override
  State<NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {
  final ValueNotifier<EntryCategoryType> categoryTypeNotifier =
      ValueNotifier(EntryCategoryType.expense);
  final isExpense = ValueNotifier(false);

  Color categoryColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      contentPadding:
          const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 14),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("New Category", style: BudgetronFonts.nunitoSize18Weight600),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close),
                //TODO dismiss keyboard with FocusManager.instance.primaryFocus?.unfocus()
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Color and category name",
                style: BudgetronFonts.nunitoSize16Weight400,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: () => _chooseColor(),
                child: Container(
                    padding: EdgeInsets.zero,
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                        color: categoryColor,
                        border: Border.all(
                            color: BudgetronColors.black, width: 1.5)),
                    child: const Icon(Icons.add)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BudgetronTextField(
                  hintText: "Enter category name",
                  autoFocus: true,
                  onSubmitted: (value) {
                    objectBox.addCategory(EntryCategory(
                        name: value.toString().trim(),
                        isExpense: categoryTypeNotifier.value ==
                            EntryCategoryType.expense,
                        usages: 0,
                        color:
                            'ff${categoryColor.value.toRadixString(16).substring(2)}'));
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
        ]),
      ),
    );
  }

  void _chooseColor() {
    //placeholder
    int i = Random().nextInt(5);
    Color color;
    switch (i) {
      case 0:
        color = Colors.red;
        break;
      case 1:
        color = Colors.indigo;
        break;
      case 2:
        color = Colors.green;
        break;
      case 3:
        color = Colors.orange;
        break;
      case 4:
        color = Colors.blue;
        break;
      case 5:
        color = Colors.pink;
        break;
      default:
        color = Colors.black;
    }

    setState(() {
      categoryColor = color;
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

enum EntryCategoryType { expense, income }
