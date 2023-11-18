import 'package:budgetron/db/category_controller.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/routes/popups/category/category_color_selection_popup.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/ui/data/fonts.dart';

class EditCategoryDialog extends StatefulWidget {
  final ValueNotifier<Color?> colorNotifier = ValueNotifier(null);
  final TextEditingController textController = TextEditingController();
  final EntryCategory category;

  EditCategoryDialog({super.key, required this.category});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  @override
  Widget build(BuildContext context) {
    widget.colorNotifier.value =
        CategoryService.stringToColor(widget.category.color);
    widget.textController.text = widget.category.name;

    return DockedDialog(
        title: "Edit Category",
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
                child: ValueListenableBuilder(
                  valueListenable: widget.colorNotifier,
                  builder: (context, value, _) {
                    return Container(
                        padding: EdgeInsets.zero,
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                            color: widget.colorNotifier.value,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5)));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BudgetronSmallTextField(
                  textController: widget.textController,
                  inputType: TextInputType.text,
                  hintText: "Enter category name",
                  autoFocus: true,
                  onSubmitted: () => {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _resolveButtons()
        ]));
  }

  void _setColor(Color value) => widget.colorNotifier.value = value;

  Widget _resolveButtons() {
    if (widget.category.usages == 0) {
      return Row(
        children: [
          Expanded(
            child: BudgetronLargeTextButton(
                text: 'Delete',
                backgroundColor: Theme.of(context).colorScheme.error,
                onTap: () => _showDeleteCategoryDialog(),
                textStyle: BudgetronFonts.nunitoSize18Weight500White,
                isActive: () => true,
                listenables: const []),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: BudgetronLargeTextButton(
                text: 'Save',
                backgroundColor: Theme.of(context).colorScheme.primary,
                onTap: () => _updateCategory(),
                textStyle: BudgetronFonts.nunitoSize18Weight500White,
                isActive: _isValid,
                listenables: [widget.colorNotifier, widget.textController]),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: BudgetronLargeTextButton(
                text: 'Save',
                backgroundColor: Theme.of(context).colorScheme.primary,
                onTap: () => _updateCategory(),
                textStyle: BudgetronFonts.nunitoSize18Weight500White,
                isActive: _isValid,
                listenables: [widget.colorNotifier, widget.textController]),
          ),
        ],
      );
    }
  }

  void _showDeleteCategoryDialog() {
    CategoryService.deleteCategory(widget.category.id);

    Navigator.pop(context);
  }

  void _updateCategory() {
    widget.category.name = widget.textController.text.trim();
    widget.category.color =
        CategoryService.colorToString(widget.colorNotifier.value!);

    CategoryController.updateCategory(widget.category);

    Navigator.pop(context);
  }

  bool _isValid() {
    EntryCategory category = widget.category;

    return category.color !=
            CategoryService.colorToString(widget.colorNotifier.value!) ||
        category.name.toLowerCase() != widget.textController.text.toLowerCase();
  }
}
