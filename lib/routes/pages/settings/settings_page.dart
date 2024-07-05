import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';
import 'package:budgetron/routes/pages/settings/style_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO replace with budgetron app bar
      appBar: const BudgetronAppBar(
        title: 'Settings',
        leading: ArrowBackIconButton(),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
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

    final widgets = [
      SettingsListTile(
          onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const StylePage()))
              },
          iconData: Icons.color_lens_outlined,
          topText: 'Style and appearance',
          bottomText: 'Theme and icons'),
      SettingsListTile(
          onTap: () => {},
          iconData: Icons.color_lens_outlined,
          topText: 'Language'),
    ];

    return Expanded(
        child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return widgets[index];
                },
                separatorBuilder: (context, _) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: HorizontalSeparator(),
                  );
                },
                itemCount: widgets.length)));
  }
}

class SettingsListTile extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  final String topText;
  final String bottomText;

  const SettingsListTile(
      {super.key,
      required this.iconData,
      required this.topText,
      required this.onTap,
      this.bottomText = ''});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;
    final textColumn = [
      Text(
        topText,
        style: theme.textTheme.bodyMedium,
      )
    ];

    final isNotEmpty = bottomText.isNotEmpty;
    if (isNotEmpty) {
      textColumn.add(Text(
        bottomText,
        style: theme.textTheme.labelMedium!
            .apply(color: colorScheme.surfaceContainerHigh),
      ));
    }

    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Icon(iconData, color: colorScheme.primary),
              const SizedBox(width: 8),
              Column(
                  mainAxisAlignment: isNotEmpty
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: textColumn),
            ]),
            Icon(Icons.arrow_right, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

//REFACTOR into proper widgets
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
