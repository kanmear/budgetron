import 'package:flutter/material.dart';

import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/db/accounts_controller.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/account/transfer.dart';
import 'package:budgetron/ui/classes/dropdown_button.dart';
import 'package:budgetron/logic/account/account_service.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/text_fields/text_field.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';

class AccountTransferDialog extends StatelessWidget {
  final ValueNotifier<Account?> fromAccountNotifier = ValueNotifier(null);
  final ValueNotifier<Account?> toAccountNotifier = ValueNotifier(null);
  final TextEditingController textController = TextEditingController();

  final Account account;

  AccountTransferDialog({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    fromAccountNotifier.value = account;

    return DockedDialog(
        title: 'Transfer',
        body: Column(children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text('From account', style: theme.textTheme.labelSmall)),
          const SizedBox(height: 4),
          BudgetronDropdownButton(
              valueNotifier: fromAccountNotifier,
              items: _getAccountsFrom(),
              leading: _getLeading,
              hint: 'Select an account',
              fallbackValue: 'No available accounts'),
          const SizedBox(height: 16),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('To account', style: theme.textTheme.labelSmall)),
          const SizedBox(height: 4),
          ValueListenableBuilder(
              valueListenable: fromAccountNotifier,
              builder: (BuildContext context, Account? value, Widget? child) {
                //FIX throws an exception, but seems to work
                toAccountNotifier.value = null;

                return BudgetronDropdownButton(
                    valueNotifier: toAccountNotifier,
                    items: _getAccountsTo(),
                    leading: _getLeading,
                    hint: 'Select an account',
                    fallbackValue: 'No available accounts');
              }),
          const SizedBox(height: 16),
          Align(
              alignment: Alignment.centerLeft,
              child:
                  Text('Transfer amount', style: theme.textTheme.labelSmall)),
          const SizedBox(height: 4),
          CustomTextField(
              textController: textController,
              inputType: TextInputType.number,
              hintText: '',
              autoFocus: false,
              onSubmitted: (value) => {}),
          const SizedBox(height: 24),
          BudgetronLargeTextButton(
              text: 'Transfer',
              backgroundColor: theme.colorScheme.secondary,
              onTap: () => _createTransfer(context),
              isActive: _isValid,
              listenables: [
                fromAccountNotifier,
                toAccountNotifier,
                textController
              ])
        ]));
  }

  Future<List<Object>> _getAccountsFrom() async {
    var accounts = await Future(() => AccountsController.getAccounts().first);
    return accounts;
  }

  Future<List<Object>> _getAccountsTo() async {
    var accounts = await Future(() => AccountsController.getAccounts().first);

    return accounts.where((acc) => acc != fromAccountNotifier.value!).toList();
  }

  void _createTransfer(BuildContext context) {
    Transfer transfer = Transfer(
      value: double.parse(textController.text),
      dateTime: DateTime.now(),
    );
    transfer.fromAccount.target = fromAccountNotifier.value!;
    transfer.toAccount.target = toAccountNotifier.value!;

    AccountService.createTransfer(transfer);
    Navigator.pop(context);
  }

  Widget _getLeading(Account account) {
    return Row(children: [
      Icon(Icons.square_rounded,
          size: 18, color: CategoryService.stringToColor(account.color)),
      const SizedBox(width: 8)
    ]);
  }

  bool _isValid() {
    bool toAccountIsEmpty = toAccountNotifier.value == null;
    if (toAccountIsEmpty) return false;

    var text = textController.text;
    bool isAmountEmpty = text.isEmpty;
    if (isAmountEmpty) return false;

    var transferAmount = double.tryParse(text);
    if (transferAmount == null || transferAmount < 0) return false;
    return true;
  }
}
