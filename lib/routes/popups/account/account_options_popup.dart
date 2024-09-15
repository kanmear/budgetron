import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/account/transaction.dart';
import 'package:budgetron/ui/classes/buttons/button_with_icon.dart';
import 'package:budgetron/routes/popups/account/edit_account_popup.dart';
import 'package:budgetron/routes/pages/account/operations_page/account_operations_page.dart';
import 'package:budgetron/routes/popups/account/account_transfer_popup.dart';
import 'package:budgetron/routes/pages/account/account_transaction_page.dart';

//TODO update on account change (e.g. balance update after transfer)
class AccountOptionsDialog extends StatelessWidget {
  final Account account;

  const AccountOptionsDialog({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DockedDialog(
        title: "${account.name} Account",
        body: Column(children: [
          CurrentBalance(account: account),
          const SizedBox(height: 16),
          ButtonWithIcon(
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    EditAccountDialog(account: account)),
            icon: Icon(Icons.edit, color: theme.colorScheme.primary),
            text: Text('Edit', style: theme.textTheme.bodyMedium),
            backgroundColor: theme.colorScheme.surfaceTint,
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => _navigateToOperationsPage(context),
                    icon: Icon(Icons.list, color: theme.colorScheme.primary),
                    text: Text('Operations', style: theme.textTheme.bodyMedium),
                    backgroundColor: theme.colorScheme.surfaceTint)),
            const SizedBox(width: 16),
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AccountTransferDialog(account: account)),
                    icon: Icon(Icons.credit_card,
                        color: theme.colorScheme.primary),
                    text: Text('Transfer', style: theme.textTheme.bodyMedium),
                    backgroundColor: theme.colorScheme.surfaceTint)),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => _navigateToTransferPage(
                          context,
                          TransactionType.debit,
                        ),
                    icon: Icon(Icons.trending_up,
                        color: theme.colorScheme.onPrimary),
                    text: Text('Debit',
                        style: theme.textTheme.bodyMedium!
                            .apply(color: theme.colorScheme.onPrimary)),
                    backgroundColor: theme.colorScheme.secondary)),
            const SizedBox(width: 16),
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => _navigateToTransferPage(
                          context,
                          TransactionType.credit,
                        ),
                    icon: Icon(Icons.trending_down,
                        color: theme.colorScheme.onPrimary),
                    text: Text('Credit',
                        style: theme.textTheme.bodyMedium!
                            .apply(color: theme.colorScheme.onPrimary)),
                    backgroundColor: theme.colorScheme.error))
          ])
        ]));
  }

  void _navigateToTransferPage(
      BuildContext context, TransactionType transactionType) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AccountTransactionPage(
                transactionType: transactionType, account: account)));
  }

  void _navigateToOperationsPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AccountOperationsPage(account: account)));
  }
}

class CurrentBalance extends StatelessWidget {
  final Account account;

  const CurrentBalance({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    String currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.secondary)),
        padding: const EdgeInsets.all(12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Current balance', style: theme.textTheme.bodyMedium),
          Row(children: [
            Text(account.balance.toStringAsFixed(2),
                style: theme.textTheme.bodyMedium),
            Text(" $currency", style: theme.textTheme.titleSmall)
          ])
        ]));
  }
}
