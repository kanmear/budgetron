import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/db/groups_controller.dart';
import 'package:budgetron/models/category/group.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/multi_select_button.dart';
import 'package:budgetron/routes/pages/group/group_page.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/classes/text_fields/text_field.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/routes/pages/category/category_selection_page.dart';

//TODO check if use of state is necessary here
class NewGroupDialog extends StatefulWidget {
  final ValueNotifier<List<EntryCategory>> categoriesNotifier =
      ValueNotifier([]);

  NewGroupDialog({super.key});

  @override
  State<NewGroupDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewGroupDialog> {
  final ValueNotifier<String> textNotifier =
      ValueNotifier('Choose categories to group');
  final ValueNotifier<TextStyle> styleNotifier =
      ValueNotifier(BudgetronFonts.fallbackStyle);
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    styleNotifier.value = theme.textTheme.bodyMedium!;
    // .apply(color: theme.colorScheme.surfaceContainerHigh);

    return DockedDialog(
        title: 'New Group',
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Name', style: theme.textTheme.labelSmall),
          const SizedBox(height: 4),
          CustomTextField(
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
          BudgetronLargeTextButton(
              text: 'Create group',
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onTap: () => _addGroup(),
              isActive: _isValid,
              listenables: [textController, widget.categoriesNotifier])
        ]));
  }

  void _setCategories(List<EntryCategory> groups) {
    setState(() {
      widget.categoriesNotifier.value = groups;
    });
    _updateCategorySelectText(groups.length);
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

  void _setDefaultValues() {
    setState(() {
      widget.categoriesNotifier.value = [];
    });
    _updateCategorySelectText(0);
  }

  bool _isValid() =>
      textController.text.isNotEmpty &&
      widget.categoriesNotifier.value.isNotEmpty;

  void _addGroup() {
    CategoryGroup group = CategoryGroup(name: textController.text);
    group.categories.addAll(widget.categoriesNotifier.value);

    GroupsController.addGroup(group);
    Navigator.pop(context);
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

  void _removeCategory(EntryCategory category) {
    setState(() {
      widget.categoriesNotifier.value.remove(category);
    });
    _updateCategorySelectText(widget.categoriesNotifier.value.length);
  }

  void _updateCategorySelectText(int length) {
    final theme = Theme.of(context);

    if (length == 0) {
      textNotifier.value = 'Choose categories to group';
      styleNotifier.value = theme.textTheme.bodyMedium!;
    } else {
      textNotifier.value =
          "$length ${length == 1 ? 'category' : 'categories'} chosen";
      styleNotifier.value = theme.textTheme.bodyMedium!;
    }
  }
}
