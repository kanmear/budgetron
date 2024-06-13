import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/ui/classes/tab_switch.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/ui/classes/select_button.dart';
import 'package:budgetron/models/account/transaction.dart';
import 'package:budgetron/ui/classes/keyboard/number_keyboard.dart';
import 'package:budgetron/ui/classes/text_fields/large_text_field.dart';
import 'package:budgetron/routes/pages/account/account_selection_page.dart';
import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';

class AccountTransactionPage extends StatelessWidget {
  final ValueNotifier<Account?> accountNotifier = ValueNotifier(null);
  final TransactionType transactionType;
  final Account account;

  AccountTransactionPage({
    super.key,
    required this.transactionType,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<TransactionType> tabNotifier =
        ValueNotifier(transactionType);
    final TextEditingController textController = TextEditingController();

    accountNotifier.value = account;

    return Scaffold(
        appBar:
            const BudgetronAppBar(leading: ArrowBackIconButton(), title: ''),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(children: [
          BudgetronTabSwitch(
              valueNotifier: tabNotifier,
              tabs: const [TransactionType.debit, TransactionType.credit]),
          TransactionValueTextField(
            tabNotifier: tabNotifier,
            textController: textController,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(children: [
                BudgetronSelectButton(
                    onTap: () => _navigateToAccountSelection(context),
                    valueNotifier: accountNotifier,
                    hintText: '')
              ])),
          const SizedBox(height: 16),
          BudgetronNumberKeyboard(
              textController: textController,
              onConfirmAction: _createNewTransaction,
              isSubmitAvailable: _isSubmitAvailable)
        ]));
  }

  void _navigateToAccountSelection(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AccountSelectionPage()));

    if (result != null) accountNotifier.value = result;
  }

  void _createNewTransaction() {
    //TODO
  }

  bool _isSubmitAvailable(NumberKeyboardService keyboardService) =>
      keyboardService.isValueValidForCreation();
}

class TransactionValueTextField extends StatelessWidget {
  final ValueNotifier<TransactionType> tabNotifier;
  final TextEditingController textController;

  const TransactionValueTextField({
    super.key,
    required this.tabNotifier,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Center(
            child: BudgetronLargeTextField(
                textController: textController,
                autoFocus: true,
                onSubmitted: () => {},
                inputType: TextInputType.number,
                showCursor: false,
                readOnly: true)),
      ),
    );
  }
}
