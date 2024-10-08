import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/db/accounts_controller.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/popups/account/new_account_popup.dart';

class AccountSelectionPage extends StatelessWidget {
  const AccountSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> nameFilter = ValueNotifier('');

    return Scaffold(
        //TODO add search to appbar
        appBar: const BudgetronAppBar(
            leading: ArrowBackIconButton(), title: 'Choose account'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(children: [AccountsList(nameFilter: nameFilter)]),
        floatingActionButton: BudgetronFloatingActionButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => NewAccountDialog())));
  }
}

//NOTE almost a copy paste of AccountsList from accounts_page.dart
//AccountTile is also a close copy paste
class AccountsList extends StatelessWidget {
  const AccountsList({super.key, required this.nameFilter});

  final ValueNotifier<String> nameFilter;

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
                          account: accounts[index], currency: currency);
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

  const AccountListTile(
      {super.key, required this.account, required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectAccount(context, account),
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

  void _selectAccount(BuildContext context, Account account) =>
      Navigator.pop(context, account);
}
