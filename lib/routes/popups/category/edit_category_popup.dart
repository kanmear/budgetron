import 'package:budgetron/db/category_controller.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/routes/popups/category/category_color_selection_popup.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/category/category.dart';

class EditCategoryDialog extends StatefulWidget {
  final ValueNotifier<Color?> colorNotifier = ValueNotifier(null);
  final TextEditingController textController = TextEditingController();
  final EntryCategory category;

  EditCategoryDialog({super.key, required this.category});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late Future<bool> isCategoryUnused;

  @override
  initState() {
    super.initState();
    isCategoryUnused = CategoryService.isCategoryUnused(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    widget.colorNotifier.value =
        CategoryService.stringToColor(widget.category.color);
    widget.textController.text = widget.category.name;

    return DockedDialog(
        title: "Edit Category",
        body: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Color and category name',
              style: theme.textTheme.bodyMedium,
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
                                color: theme.colorScheme.primary, width: 1.5)));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BudgetronSmallTextField(
                  textController: widget.textController,
                  inputType: TextInputType.text,
                  hintText: 'Enter category name',
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
    return FutureBuilder(
        future: isCategoryUnused,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null && snapshot.data!) {
              return Row(
                children: [
                  Expanded(
                    child: BudgetronLargeTextButton(
                        text: 'Delete',
                        backgroundColor: Theme.of(context).colorScheme.error,
                        onTap: () => _showDeleteCategoryDialog(),
                        isActive: () => true,
                        listenables: const []),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BudgetronLargeTextButton(
                        text: 'Save',
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        onTap: () => _updateCategory(),
                        isActive: _isValid,
                        listenables: [
                          widget.colorNotifier,
                          widget.textController
                        ]),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    child: BudgetronLargeTextButton(
                        text: 'Save',
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        onTap: () => _updateCategory(),
                        isActive: _isValid,
                        listenables: [
                          widget.colorNotifier,
                          widget.textController
                        ]),
                  ),
                ],
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  void _showDeleteCategoryDialog() {
    CategoryService.deleteCategory(widget.category);

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
        category.name != widget.textController.text;
  }
}
