import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/db/groups_controller.dart';
import 'package:budgetron/models/category/group.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/multi_select_button.dart';
import 'package:budgetron/routes/pages/group/group_page.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/routes/popups/group/delete_group_popup.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/routes/pages/category/category_selection_page.dart';

class EditGroupDialog extends StatefulWidget {
  final ValueNotifier<bool> firstTimeLoadNotifier = ValueNotifier(true);
  final ValueNotifier<List<EntryCategory>> categoriesNotifier =
      ValueNotifier([]);
  final CategoryGroup group;
  final Function onGroupUpdate;

  EditGroupDialog(
      {super.key, required this.group, required this.onGroupUpdate});

  @override
  State<EditGroupDialog> createState() => _EditGroupDialogState();
}

class _EditGroupDialogState extends State<EditGroupDialog> {
  final ValueNotifier<String> textNotifier =
      ValueNotifier('Choose categories to group');
  final ValueNotifier<TextStyle> styleNotifier =
      ValueNotifier(BudgetronFonts.fallbackStyle);
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    styleNotifier.value = theme.textTheme.bodyMedium!
        .apply(color: theme.colorScheme.surfaceContainerHigh);

    if (widget.firstTimeLoadNotifier.value) {
      CategoryGroup group = widget.group;

      textController.text = group.name;
      widget.categoriesNotifier.value = group.categories.toList();
      _updateCategorySelectText(group.categories.length);

      widget.firstTimeLoadNotifier.value = false;
    }

    return DockedDialog(
        title: 'Edit Group',
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Name', style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          BudgetronSmallTextField(
              textController: textController,
              hintText: 'Enter group name',
              autoFocus: false,
              onSubmitted: () => {},
              inputType: TextInputType.text),
          const SizedBox(height: 16),
          Text('Categories', style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          ValueListenableBuilder(
              valueListenable: textNotifier,
              builder: (BuildContext context, String textValue, _) {
                return Column(children: [
                  BudgetronMultiSelectButton(
                      onTap: () =>
                          _navigateToCategorySelection(context, _setCategories),
                      text: Text(textValue, style: styleNotifier.value)),
                  _resolveCategoriesDisplay()
                ]);
              }),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: BudgetronLargeTextButton(
                    text: 'Delete',
                    backgroundColor: theme.colorScheme.error,
                    onTap: () => _showDeleteGroupDialog(),
                    isActive: () => true,
                    listenables: [textController, widget.categoriesNotifier]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BudgetronLargeTextButton(
                    text: 'Save',
                    backgroundColor: theme.colorScheme.primary,
                    onTap: () => _saveGroup(),
                    isActive: _isValid,
                    listenables: [textController, widget.categoriesNotifier]),
              ),
            ],
          )
        ]));
  }

  Future<void> _navigateToCategorySelection(
      BuildContext context, Function callback) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategorySelectionPage(
                categoryTypeNotifier: ValueNotifier(EntryCategoryType.expense),
                categories: widget.categoriesNotifier.value,
                isMultipleSelection: true)));

    if (!mounted) return;

    if (result != null) {
      callback.call(result);
    } else {
      _setDefaultValues();
    }
  }

  void _setCategories(List<EntryCategory> groups) {
    setState(() {
      widget.categoriesNotifier.value = groups;
    });
    _updateCategorySelectText(groups.length);
  }

  Widget _resolveCategoriesDisplay() {
    final theme = Theme.of(context);

    var categories = widget.categoriesNotifier.value;

    if (categories.isNotEmpty) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 8),
        Container(
            //HACK height value is take from design
            constraints: const BoxConstraints(maxHeight: 130),
            child: SingleChildScrollView(
                child: Wrap(spacing: 8, runSpacing: 8, children: [
              for (var category in categories)
                GroupCategoryTile(
                    category: category,
                    isRemovable: true,
                    onCloseTap: _removeCategory,
                    theme: theme)
            ])))
      ]);
    }
    return const SizedBox();
  }

  //TODO update overview page on group change
  void _saveGroup() {
    CategoryGroup group = widget.group;

    group.name = textController.text;

    group.categories.removeRange(0, group.categories.length);
    group.categories.addAll(widget.categoriesNotifier.value);

    GroupsController.addGroup(group);
    widget.onGroupUpdate();
    Navigator.pop(context);
  }

  bool _isValid() {
    var isNewName = textController.text != widget.group.name;
    if (isNewName) return true;

    var originalCategories = widget.group.categories.toList();
    var newCategories = widget.categoriesNotifier.value;
    var isSimplyChanged = originalCategories.length != newCategories.length;
    if (isSimplyChanged) return true;

    for (var category in originalCategories) {
      if (!newCategories.contains(category)) return true;
    }
    return false;
  }

  void _showDeleteGroupDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            DeleteGroupDialog(groupId: widget.group.id));
  }

  void _setDefaultValues() {
    setState(() {
      widget.categoriesNotifier.value = [];
    });
    _updateCategorySelectText(0);
  }

  void _updateCategorySelectText(int length) {
    final theme = Theme.of(context);

    if (length == 0) {
      textNotifier.value = 'Choose categories to group';
      styleNotifier.value = theme.textTheme.bodyMedium!
          .apply(color: theme.colorScheme.surfaceContainerHigh);
    } else {
      textNotifier.value =
          "$length ${length == 1 ? 'category' : 'categories'} chosen";
      styleNotifier.value = theme.textTheme.bodyMedium!;
    }
  }

  void _removeCategory(EntryCategory category) {
    setState(() {
      widget.categoriesNotifier.value.remove(category);
    });
    _updateCategorySelectText(widget.categoriesNotifier.value.length);
  }
}
