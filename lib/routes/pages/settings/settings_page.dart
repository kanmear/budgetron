import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/icons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: const ArrowBackIconButton(),
        leadingWidth: 48,
        title: Text('Settings', style: BudgetronFonts.nunitoSize18Weight600),
        titleSpacing: 0,
        toolbarHeight: 48,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const Column(
        children: [
          SettingsList(),
        ],
      ),
    );
  }
}

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    return Expanded(
        child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                CurrencySelector(appData: appData),
                DateModeSelector(appData: appData),
              ],
            )));
  }
}

class CurrencySelector extends StatefulWidget {
  final AppData appData;

  const CurrencySelector({super.key, required this.appData});

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  @override
  Widget build(BuildContext context) {
    String currentValue = widget.appData.currency;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Currency', style: BudgetronFonts.nunitoSize16Weight600),
      //TODO replace with a separate page (similar to Categories)
      DropdownButton<String>(
          value: currentValue,
          items: [
            DropdownMenuItem(
              value: 'BYN',
              child: Text('BYN', style: BudgetronFonts.nunitoSize14Weight600),
            ),
            DropdownMenuItem(
              value: 'USD',
              child: Text('USD', style: BudgetronFonts.nunitoSize14Weight600),
            )
          ],
          onChanged: (value) {
            setState(() {
              currentValue = value!;
            });
            widget.appData.setCurrency(value!);
          })
    ]);
  }
}

class DateModeSelector extends StatefulWidget {
  final ValueNotifier<bool> switchNotifier = ValueNotifier(false);
  final AppData appData;

  DateModeSelector({super.key, required this.appData});

  @override
  State<DateModeSelector> createState() => _DateModeSelectorState();
}

class _DateModeSelectorState extends State<DateModeSelector> {
  @override
  Widget build(BuildContext context) {
    widget.switchNotifier.value = widget.appData.legacyDateSelector;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Use legacy view for Entries',
          style: BudgetronFonts.nunitoSize16Weight600),
      Switch(
          onChanged: (bool value) {
            setState(() => widget.switchNotifier.value = value);
            widget.appData.setLegacyDateSelector(value);
          },
          value: widget.switchNotifier.value,
          activeColor: Theme.of(context).colorScheme.secondary)
    ]);
  }
}
