import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/radio_list_tile.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/routes/popups/category/category_color_selection_popup.dart';

class NewCategoryDialog extends StatelessWidget {
  final ValueNotifier<EntryCategoryType> categoryTypeNotifier;

  final TextEditingController textController = TextEditingController();
  final ValueNotifier<Color?> colorNotifier = ValueNotifier(null);

  NewCategoryDialog({super.key, required this.categoryTypeNotifier});

  @override
  Widget build(BuildContext context) {
    return DockedDialog(
        title: "New Category",
        body: Column(children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text("Color and category name",
                  style: BudgetronFonts.nunitoSize16Weight400)),
          const SizedBox(height: 8),
          Row(children: [
            InkWell(
                onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const CategoryColorDialog())
                    .then((value) => _setColor(value)),
                child: ValueListenableBuilder(
                    valueListenable: colorNotifier,
                    builder: (BuildContext context, value, Widget? child) {
                      return Container(
                          padding: EdgeInsets.zero,
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                              color: value ?? Colors.white,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5)),
                          child: value == null ? const Icon(Icons.add) : null);
                    })),
            const SizedBox(width: 8),
            Expanded(
                child: BudgetronSmallTextField(
                    textController: textController,
                    inputType: TextInputType.text,
                    hintText: "Enter category name",
                    autoFocus: false,
                    onSubmitted: () {}))
          ]),
          const SizedBox(height: 24),
          //HACK there should be a better way to do this
          Transform.translate(
              offset: const Offset(-3.5, 0),
              child: CategoryTypeRadioButtons(
                  categoryTypeNotifier: categoryTypeNotifier)),
          const SizedBox(height: 24),
          BudgetronLargeTextButton(
              text: 'Create category',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () => _addCategory(context),
              textStyle: BudgetronFonts.nunitoSize18Weight500White,
              isActive: _isValid,
              listenables: [textController, colorNotifier])
        ]));
  }

  void _setColor(Color? value) {
    if (value != null) colorNotifier.value = value;
  }

  void _addCategory(BuildContext context) {
    String name = textController.text.trim();
    Color color = colorNotifier.value!;

    CategoryController.addCategory(EntryCategory(
        name: name,
        isExpense: categoryTypeNotifier.value == EntryCategoryType.expense,
        color: CategoryService.colorToString(color)));
    Navigator.pop(context);
  }

  bool _isValid() =>
      textController.text.isNotEmpty && colorNotifier.value != null;
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
          padding: EdgeInsets.zero,
          value: EntryCategoryType.expense,
          groupValue: widget.categoryTypeNotifier.value,
          onChanged: (value) =>
              {setState(() => widget.categoryTypeNotifier.value = value!)}),
      const SizedBox(width: 16),
      BudgetronRadioListTile(
          label: "Income",
          padding: EdgeInsets.zero,
          value: EntryCategoryType.income,
          groupValue: widget.categoryTypeNotifier.value,
          onChanged: (value) =>
              {setState(() => widget.categoryTypeNotifier.value = value!)})
    ]);
  }
}
