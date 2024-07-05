import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/account/transaction.dart';
import 'package:budgetron/ui/classes/buttons/button_with_icon.dart';
import 'package:budgetron/routes/popups/account/edit_account_popup.dart';
import 'package:budgetron/routes/pages/account/account_operations_page.dart';
import 'package:budgetron/routes/popups/account/account_transfer_popup.dart';
import 'package:budgetron/routes/pages/account/account_transaction_page.dart';

//TODO update on account change (e.g. balance update after transfer)
class AccountOptionsDialog extends StatelessWidget {
  final Account account;

  const AccountOptionsDialog({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
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
              iconData: Icons.edit,
              text: 'Edit'),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => _navigateToOperationsPage(context),
                    iconData: Icons.list,
                    text: 'Operations')),
            const SizedBox(width: 16),
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AccountTransferDialog(account: account)),
                    iconData: Icons.credit_card,
                    text: 'Transfer')),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => _navigateToTransferPage(
                          context,
                          TransactionType.debit,
                        ),
                    iconData: Icons.trending_up,
                    text: 'Debit')),
            const SizedBox(width: 16),
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => _navigateToTransferPage(
                          context,
                          TransactionType.credit,
                        ),
                    iconData: Icons.trending_down,
                    text: 'Credit'))
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
    final theme = Theme.of(context);

    final currency = Provider.of<AppData>(context).currency;

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.primary)),
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
