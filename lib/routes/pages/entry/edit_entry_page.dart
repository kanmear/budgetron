import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/ui/classes/tab_switch.dart';
import 'package:budgetron/ui/classes/time_button.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/ui/classes/date_button.dart';
import 'package:budgetron/db/accounts_controller.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/ui/classes/select_button.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/classes/keyboard/number_keyboard.dart';
import 'package:budgetron/routes/popups/entry/delete_entry_popup.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/routes/pages/account/account_selection_page.dart';
import 'package:budgetron/routes/pages/category/category_selection_page.dart';
import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';
import 'package:budgetron/routes/pages/entry/widgets/entry_value_input_field.dart';

class EditEntryPage extends StatelessWidget {
  final Entry entry;

  final TextEditingController textController = TextEditingController();
  final ValueNotifier<EntryCategoryType> tabNotifier =
      ValueNotifier(EntryCategoryType.expense);
  final ValueNotifier<EntryCategory?> categoryNotifier = ValueNotifier(null);
  final ValueNotifier<Account?> accountNotifier = ValueNotifier(null);
  final ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> timeNotifier = ValueNotifier(TimeOfDay.now());
  final ValueNotifier<bool> isKeyboardOnNotifier = ValueNotifier(true);

  EditEntryPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final categoryType = entry.category.target!.isExpense
        ? EntryCategoryType.expense
        : EntryCategoryType.income;

    tabNotifier.value = categoryType;
    textController.text = entry.value.abs().toStringAsFixed(2);
    categoryNotifier.value = entry.category.target!;
    if (entry.account.target != null) {
      accountNotifier.value = entry.account.target!;
    }

    final entryDateTime = entry.dateTime;
    dateNotifier.value = entryDateTime;
    timeNotifier.value =
        TimeOfDay(hour: entryDateTime.hour, minute: entryDateTime.minute);

    final ValueNotifier<MathOperation> currentOperationNotifier =
        ValueNotifier(MathOperation.none);
    final NumberKeyboardService keyboardService =
        NumberKeyboardService(textController, currentOperationNotifier);

    return Scaffold(
        appBar: BudgetronAppBar(
          leading: const ArrowBackIconButton(),
          title: 'Edit entry',
          actions: [EntryDeleteIcon(entry: entry)],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            BudgetronDisabledTabSwitch(
              tabs: const [EntryCategoryType.expense, EntryCategoryType.income],
              selectedTab: categoryType,
            ),
            Expanded(
                child: EntryValueInputField(
              tabNotifier: tabNotifier,
              textController: textController,
            )),
            EntryParameters(
                tabNotifier: tabNotifier,
                categoryNotifier: categoryNotifier,
                accountNotifier: accountNotifier,
                isKeyboardOnNotifier: isKeyboardOnNotifier,
                dateNotifier: dateNotifier,
                timeNotifier: timeNotifier),
            const SizedBox(height: 16),
            BudgetronNumberKeyboard(
              keyboardService: keyboardService,
              textController: textController,
              currentOperationNotifier: currentOperationNotifier,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: BudgetronLargeTextButton(
                  text: 'Update entry',
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onTap: () => _updateEntry(context),
                  isActive: () => _isValid(keyboardService),
                  listenables: [
                    textController,
                    categoryNotifier,
                    accountNotifier,
                    dateNotifier,
                    timeNotifier,
                    currentOperationNotifier
                  ]),
            ),
            const SizedBox(height: 16)
          ],
        ));
  }

  void _updateEntry(BuildContext context) {
    double value = double.parse(textController.text);
    var dateValue = dateNotifier.value;
    var timeValue = timeNotifier.value;
    var date = DateTime(dateValue.year, dateValue.month, dateValue.day,
        timeValue.hour, timeValue.minute);

    Entry updatedEntry = Entry(value: value, dateTime: date);
    if (accountNotifier.value != null) {
      updatedEntry.account.target = accountNotifier.value;
    }

    EntryService.createEntry(updatedEntry, entry.category.target!);
    EntryService.deleteEntry(entry);
    Navigator.pop(context);
  }

  bool _isValid(NumberKeyboardService keyboardService) {
    return categoryNotifier.value != entry.category.target ||
        accountNotifier.value != entry.account.target ||
        _isDateUpdated() ||
        (_isValueUpdated() && keyboardService.isValueValidForCreation());
  }

  bool _isValueUpdated() {
    var newValue = double.tryParse(textController.text);
    if (newValue == null) return false;

    return !(newValue == 0 || newValue == entry.value.abs());
  }

  bool _isDateUpdated() {
    var oldDateFull = entry.dateTime;
    var oldDate =
        DateTime(oldDateFull.year, oldDateFull.month, oldDateFull.day);

    var newDateFull = dateNotifier.value;
    var newDate =
        DateTime(newDateFull.year, newDateFull.month, newDateFull.day);

    var oldTime = TimeOfDay(hour: oldDateFull.hour, minute: oldDateFull.minute);
    var newTime = timeNotifier.value;

    return oldDate != newDate || oldTime != newTime;
  }
}

class EntryParameters extends StatefulWidget {
  final ValueNotifier<EntryCategoryType> tabNotifier;
  final ValueNotifier<Account?> accountNotifier;
  final ValueNotifier<EntryCategory?> categoryNotifier;

  final ValueNotifier<DateTime> dateNotifier;
  final ValueNotifier<TimeOfDay> timeNotifier;

  final ValueNotifier<bool> isKeyboardOnNotifier;

  const EntryParameters(
      {super.key,
      required this.tabNotifier,
      required this.accountNotifier,
      required this.categoryNotifier,
      required this.dateNotifier,
      required this.timeNotifier,
      required this.isKeyboardOnNotifier});

  @override
  State<EntryParameters> createState() => _EntryParametersState();
}

class _EntryParametersState extends State<EntryParameters> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final accountId = Provider.of<AppData>(context).defaultAccountId;

    Widget? defaultValue =
        Text('No account', style: theme.textTheme.bodyMedium);
    if (accountId > 0) {
      widget.accountNotifier.value = AccountsController.getAccount(accountId);
      defaultValue = null;
    }

    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                  child: BudgetronSelectButton(
                      onTap: () => _navigateToCategorySelection(context),
                      valueNotifier: widget.categoryNotifier,
                      hintText: 'Select category')),
              const SizedBox(width: 16),
              Expanded(
                child: BudgetronSelectButton(
                    onTap: () => _navigateToAccountSelection(context),
                    valueNotifier: widget.accountNotifier,
                    defaultValue: defaultValue,
                    hintText: ''),
              )
            ]),
            const SizedBox(height: 16),
            Row(children: [
              BudgetronDateButton(
                  dateNotifier: widget.dateNotifier,
                  isKeyboardOnNotifier: widget.isKeyboardOnNotifier),
              const SizedBox(width: 16),
              BudgetronTimeButton(
                  timeNotifier: widget.timeNotifier,
                  isKeyboardOnNotifier: widget.isKeyboardOnNotifier)
            ]),
          ],
        ));
  }

  Future<void> _navigateToCategorySelection(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategorySelectionPage(
                categoryTypeNotifier: widget.tabNotifier)));

    if (!mounted || result == null) return;
    widget.categoryNotifier.value = result;
  }

  Future<void> _navigateToAccountSelection(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AccountSelectionPage()));

    if (!mounted || result == null) return;
    widget.accountNotifier.value = result;
  }
}

class EntryDeleteIcon extends StatelessWidget {
  final Entry entry;

  const EntryDeleteIcon({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
        onTap: () => showDialog(
            context: context,
            builder: (context) => DeleteEntryDialog(entry: entry)),
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}
