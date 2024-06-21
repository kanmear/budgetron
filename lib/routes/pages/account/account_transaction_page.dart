import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/ui/classes/tab_switch.dart';
import 'package:budgetron/ui/classes/date_button.dart';
import 'package:budgetron/ui/classes/time_button.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/ui/classes/select_button.dart';
import 'package:budgetron/models/account/transaction.dart';
import 'package:budgetron/logic/account/account_service.dart';
import 'package:budgetron/ui/classes/keyboard/number_keyboard.dart';
import 'package:budgetron/routes/pages/account/account_selection_page.dart';
import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';
import 'package:budgetron/routes/pages/entry/widgets/entry_value_input_field.dart';

class AccountTransactionPage extends StatelessWidget {
  final ValueNotifier<TransactionType> tabNotifier =
      ValueNotifier(TransactionType.credit);
  final ValueNotifier<Account?> accountNotifier = ValueNotifier(null);
  final ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> timeNotifier = ValueNotifier(TimeOfDay.now());
  final ValueNotifier<bool> isKeyboardOnNotifier = ValueNotifier(true);
  final TextEditingController textController = TextEditingController();
  final TransactionType transactionType;
  final Account account;

  AccountTransactionPage({
    super.key,
    required this.transactionType,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    tabNotifier.value = transactionType;
    accountNotifier.value = account;

    return Scaffold(
        appBar: const BudgetronAppBar(
          leading: ArrowBackIconButton(),
          title: '',
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(children: [
          BudgetronTabSwitch(
              valueNotifier: tabNotifier,
              tabs: const [TransactionType.debit, TransactionType.credit]),
          EntryValueInputField(
            tabNotifier: tabNotifier,
            textController: textController,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(children: [
                BudgetronSelectButton(
                    onTap: () => _navigateToAccountSelection(context),
                    valueNotifier: accountNotifier,
                    hintText: ''),
                const SizedBox(height: 16),
                Row(children: [
                  BudgetronDateButton(
                      dateNotifier: dateNotifier,
                      isKeyboardOnNotifier: isKeyboardOnNotifier),
                  const SizedBox(width: 16),
                  BudgetronTimeButton(
                      timeNotifier: timeNotifier,
                      isKeyboardOnNotifier: isKeyboardOnNotifier)
                ])
              ])),
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: isKeyboardOnNotifier,
            builder: (context, isKeyboardOn, _) {
              return isKeyboardOn
                  ? BudgetronNumberKeyboard(
                      textController: textController,
                      onConfirmAction: _createNewTransaction,
                      isSubmitAvailable: _isSubmitAvailable)
                  : const SizedBox();
            },
          )
        ]));
  }

  void _navigateToAccountSelection(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AccountSelectionPage()));

    if (result != null) accountNotifier.value = result;
  }

  void _createNewTransaction(String text) {
    var value = double.parse(textController.text) *
        (tabNotifier.value == TransactionType.debit ? 1 : -1);

    var dateValue = dateNotifier.value;
    var timeValue = timeNotifier.value;
    var date = DateTime(dateValue.year, dateValue.month, dateValue.day,
        timeValue.hour, timeValue.minute);

    Transaction transaction = Transaction(value: value, dateTime: date);
    transaction.account.target = accountNotifier.value;

    AccountService.createTransaction(transaction);
  }

  bool _isSubmitAvailable(NumberKeyboardService keyboardService) =>
      keyboardService.isValueValidForCreation();
}
