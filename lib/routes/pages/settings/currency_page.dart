import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/models/enums/currency.dart';
import 'package:budgetron/logic/settings/settings_service.dart';

class CurrencyPage extends StatelessWidget {
  final ValueNotifier<bool> updateNotifier;

  const CurrencyPage({super.key, required this.updateNotifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const BudgetronAppBar(
        leading: ArrowBackIconButton(),
        title: 'Select currency',
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: CurrenciesList(updateNotifier: updateNotifier)),
    );
  }
}

class CurrenciesList extends StatelessWidget {
  final ValueNotifier<bool> updateNotifier;

  const CurrenciesList({super.key, required this.updateNotifier});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return CurrencyTile(
            currency: Currency.values[index],
            updateNotifier: updateNotifier,
          );
        },
        separatorBuilder: (context, _) {
          return const SizedBox(height: 8);
        },
        itemCount: Currency.values.length);
  }
}

class CurrencyTile extends StatelessWidget {
  final ValueNotifier<bool> updateNotifier;
  final Currency currency;

  const CurrencyTile(
      {super.key, required this.currency, required this.updateNotifier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectCurrency(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(currency.code, style: theme.textTheme.headlineMedium),
                const SizedBox(width: 8),
                Text(currency.name, style: theme.textTheme.bodySmall)
              ],
            ),
            Text(currency.symbol, style: theme.textTheme.bodySmall)
          ],
        ),
      ),
    );
  }

  void _selectCurrency(BuildContext context) {
    SettingsService.setCurrency(currency.index);
    updateNotifier.value = !updateNotifier.value;
    Navigator.pop(context);
  }
}
