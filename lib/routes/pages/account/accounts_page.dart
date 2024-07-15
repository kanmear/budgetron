import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/db/accounts_controller.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/popups/account/new_account_popup.dart';
import 'package:budgetron/routes/popups/account/account_options_popup.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BudgetronAppBar(
            leading: ArrowBackIconButton(), title: 'Accounts'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const Column(children: [SizedBox(height: 8), AccountsList()]),
        floatingActionButton: BudgetronFloatingActionButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => NewAccountDialog())));
  }
}

class AccountsList extends StatelessWidget {
  const AccountsList({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    String currency = Currency.values
        .where((e) => e.index == appData.currencyIndex)
        .first
        .code;

    return Expanded(
        child: StreamBuilder<List<Account>>(
            stream: AccountsController.getAccounts(),
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                List<Account> accounts = snapshot.data!;
                // accounts.sort((a, b) => a.name.compareTo(b.name));

                return ListView.separated(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    itemBuilder: (BuildContext context, int index) {
                      return AccountListTile(
                          account: accounts[index],
                          currency: currency,
                          theme: theme);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 8);
                    },
                    itemCount: accounts.length);
              } else {
                return Center(
                    child: Text('No accounts in database',
                        style: theme.textTheme.bodyMedium!.apply(
                            color: theme.colorScheme.surfaceContainerHigh)));
              }
            }));
  }
}

class AccountListTile extends StatelessWidget {
  final Account account;
  final String currency;
  final ThemeData theme;

  const AccountListTile(
      {super.key,
      required this.account,
      required this.currency,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showDialog(
          context: context,
          builder: (context) => AccountOptionsDialog(account: account)),
      child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surfaceContainerLowest),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Icon(Icons.square_rounded,
                  size: 18,
                  color: CategoryService.stringToColor(account.color)),
              const SizedBox(width: 8),
              Text(account.name, style: theme.textTheme.bodyMedium)
            ]),
            Row(children: [
              Text(account.balance.toStringAsFixed(2),
                  style: theme.textTheme.bodyMedium),
              Text(" $currency", style: theme.textTheme.titleSmall)
            ])
          ])),
    );
  }
}
