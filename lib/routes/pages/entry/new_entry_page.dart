import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/fonts.dart';
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
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/routes/pages/account/account_selection_page.dart';
import 'package:budgetron/routes/pages/category/category_selection_page.dart';
import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';
import 'package:budgetron/routes/pages/entry/widgets/entry_value_input_field.dart';

class NewEntryPage extends StatelessWidget {
  final ValueNotifier<EntryCategoryType> tabNotifier =
      ValueNotifier(EntryCategoryType.expense);
  final ValueNotifier<Account?> accountNotifier = ValueNotifier(null);
  final ValueNotifier<EntryCategory?> categoryNotifier = ValueNotifier(null);
  final TextEditingController textController = TextEditingController(text: '0');
  final ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> timeNotifier = ValueNotifier(TimeOfDay.now());
  final ValueNotifier<bool> isKeyboardOnNotifier = ValueNotifier(true);

  NewEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<MathOperation> currentOperationNotifier =
        ValueNotifier(MathOperation.none);
    final NumberKeyboardService keyboardService =
        NumberKeyboardService(textController, currentOperationNotifier);

    return Scaffold(
        appBar: const BudgetronAppBar(
          leading: ArrowBackIconButton(),
          title: '',
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            BudgetronTabSwitch(
              valueNotifier: tabNotifier,
              tabs: const [EntryCategoryType.expense, EntryCategoryType.income],
            ),
            EntryValueInputField(
              tabNotifier: tabNotifier,
              textController: textController,
            ),
            EntryParameters(
                tabNotifier: tabNotifier,
                categoryNotifier: categoryNotifier,
                accountNotifier: accountNotifier,
                isKeyboardOnNotifier: isKeyboardOnNotifier,
                dateNotifier: dateNotifier,
                timeNotifier: timeNotifier),
            const SizedBox(height: 16),
            //TODO replace with a button so that doesn't happen:
            //isSubmitAvailable doesn't fire when tab is changed and category is dropped
            BudgetronNumberKeyboard(
              keyboardService: keyboardService,
              textController: textController,
              currentOperationNotifier: currentOperationNotifier,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: BudgetronLargeTextButton(
                  text: 'Create entry',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: () => _createNewEntry(context),
                  textStyle: BudgetronFonts.nunitoSize18Weight500White,
                  isActive: () => _isValid(keyboardService),
                  listenables: [
                    textController,
                    categoryNotifier,
                    currentOperationNotifier
                  ]),
            ),
            const SizedBox(height: 16)
          ],
        ));
  }

  void _createNewEntry(BuildContext context) {
    var value = textController.text;
    EntryCategory category = categoryNotifier.value!;

    var dateValue = dateNotifier.value;
    var timeValue = timeNotifier.value;
    var date = DateTime(dateValue.year, dateValue.month, dateValue.day,
        timeValue.hour, timeValue.minute);
    Entry entry = Entry(value: double.parse(value), dateTime: date);
    if (accountNotifier.value != null) {
      entry.account.target = accountNotifier.value;
    }

    EntryService.createEntry(entry, category);
    Navigator.pop(context);
  }

  bool _isValid(NumberKeyboardService keyboardService) {
    return double.tryParse(textController.text) != 0 &&
        categoryNotifier.value != null &&
        keyboardService.isValueValidForCreation();
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
    final accountId = Provider.of<AppData>(context).defaultAccountId;

    Widget? defaultValue =
        Text('No account', style: BudgetronFonts.nunitoSize16Weight400);
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
                child: ValueListenableBuilder(
                  valueListenable: widget.tabNotifier,
                  builder: (context, value, _) {
                    widget.categoryNotifier.value = null;

                    return BudgetronSelectButton(
                        onTap: () => _navigateToCategorySelection(context),
                        valueNotifier: widget.categoryNotifier,
                        hintText: 'Select category');
                  },
                ),
              ),
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
