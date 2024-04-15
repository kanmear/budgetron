import 'package:flutter/material.dart';
import 'package:budgetron/globals.dart' as globals;

import 'package:budgetron/logic/settings/settings_service.dart';
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

class SettingsList extends StatefulWidget {
  const SettingsList({super.key});

  @override
  State<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  String currentValue = globals.currency;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Currency', style: BudgetronFonts.nunitoSize16Weight600),
              DropdownButton<String>(
                value: currentValue,
                items: [
                  DropdownMenuItem(
                    value: 'BYN',
                    child: Text('BYN',
                        style: BudgetronFonts.nunitoSize14Weight600),
                  ),
                  DropdownMenuItem(
                    value: 'USD',
                    child: Text('USD',
                        style: BudgetronFonts.nunitoSize14Weight600),
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    currentValue = value!;
                  });
                  SettingsService.setCurrency(value!);
                  //TODO from somewhere here underlying routes should be redrawn to instantly reflect this change
                },
              )
            ],
          )
        ],
      ),
    ));
  }
}
