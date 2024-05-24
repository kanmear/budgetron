import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/db/groups_controller.dart';
import 'package:budgetron/models/category/group.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/select_button.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/routes/pages/category/category_selection_page.dart';

class NewGroupDialog extends StatefulWidget {
  NewGroupDialog({super.key});

  final ValueNotifier<List<EntryCategory>> categoriesNotifier =
      ValueNotifier([]);

  @override
  State<NewGroupDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewGroupDialog> {
  final ValueNotifier<String> textNotifier =
      ValueNotifier('Choose categories to group');
  final ValueNotifier<TextStyle> styleNotifier =
      ValueNotifier(BudgetronFonts.nunitoSize16Weight400Hint);
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DockedDialog(
        title: 'New Group',
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Name', style: BudgetronFonts.nunitoSize14Weight600),
          const SizedBox(height: 4),
          BudgetronSmallTextField(
              textController: textController,
              hintText: 'Enter group name',
              autoFocus: false,
              onSubmitted: () => {},
              inputType: TextInputType.text),
          const SizedBox(height: 16),
          Text('Categories', style: BudgetronFonts.nunitoSize14Weight600),
          const SizedBox(height: 4),
          ValueListenableBuilder(
              valueListenable: textNotifier,
              builder: (BuildContext context, String textValue, _) {
                return BudgetronSelectButton(
                    onTap: () =>
                        _navigateToCategorySelection(context, _setCategories),
                    text: Text(textValue, style: styleNotifier.value));
              }),
          const SizedBox(height: 24),
          BudgetronLargeTextButton(
              text: 'Create group',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () => _addGroup(),
              textStyle: BudgetronFonts.nunitoSize18Weight500White,
              isActive: _isValid,
              listenables: [textController, widget.categoriesNotifier])
        ]));
  }

  void _setCategories(List<EntryCategory> groups) {
    setState(() {
      widget.categoriesNotifier.value = groups;
      if (groups.isNotEmpty) {
        //FIX 1 category != categories
        textNotifier.value = "${groups.length} categories chosen";
        styleNotifier.value = BudgetronFonts.nunitoSize16Weight400;
      } else {
        textNotifier.value = 'Choose categories to group';
        styleNotifier.value = BudgetronFonts.nunitoSize16Weight400Hint;
      }
    });
  }

  Future<void> _navigateToCategorySelection(
      BuildContext context, Function callback) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategorySelectionPage(
                categoryTypeNotifier: ValueNotifier(EntryCategoryType.expense),
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
      textNotifier.value = 'Choose categories to group';
      styleNotifier.value = BudgetronFonts.nunitoSize16Weight400Hint;
    });
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
}
