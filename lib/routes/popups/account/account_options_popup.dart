import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/models/account/transaction.dart';
import 'package:budgetron/ui/classes/buttons/button_with_icon.dart';
import 'package:budgetron/routes/popups/account/edit_account_popup.dart';
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
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.surface,
              text: 'Edit'),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => {},
                    icon: const Icon(Icons.list),
                    color: Theme.of(context).colorScheme.surface,
                    text: 'Operations')),
            const SizedBox(width: 16),
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AccountTransferDialog(account: account)),
                    icon: const Icon(Icons.credit_card),
                    color: Theme.of(context).colorScheme.surface,
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
                    icon: const Icon(Icons.trending_up),
                    color: Theme.of(context).colorScheme.secondary,
                    text: 'Debit')),
            const SizedBox(width: 16),
            Expanded(
                child: ButtonWithIcon(
                    onTap: () => _navigateToTransferPage(
                          context,
                          TransactionType.credit,
                        ),
                    icon: const Icon(Icons.trending_down),
                    color: Theme.of(context).colorScheme.error,
                    text: 'Credit'))
          ])
        ]));
  }

  void _navigateToTransferPage(
      BuildContext context, TransactionType transactionType) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AccountTransactionPage(
                transactionType: transactionType, account: account)));
  }
}

class CurrentBalance extends StatelessWidget {
  final Account account;

  const CurrentBalance({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<AppData>(context).currency;

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        padding: const EdgeInsets.all(12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Current balance', style: BudgetronFonts.nunitoSize16Weight400),
          Row(children: [
            Text(account.balance.toStringAsFixed(2),
                style: BudgetronFonts.nunitoSize16Weight400),
            Text(" $currency", style: BudgetronFonts.nunitoSize12Weight400)
          ])
        ]));
  }
}
