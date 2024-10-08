import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/app_data.dart';

import 'package:budgetron/models/enums/currency.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';
import 'package:budgetron/ui/classes/text_buttons/small_text_button.dart';

import 'package:budgetron/routes/pages/settings/style_page.dart';
import 'package:budgetron/routes/pages/settings/currency_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    final theme = Theme.of(context);

    final ValueNotifier<bool> updateNotifier = ValueNotifier(false);

    return Expanded(
        child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: ValueListenableBuilder(
              valueListenable: updateNotifier,
              builder: (context, updateValue, _) {
                final appData = Provider.of<AppData>(context);

                String currency = Currency.values
                    .where((e) => e.index == appData.currencyIndex)
                    .first
                    .name;
                final widgets = [
                  SettingsListTile(
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StylePage()))
                          },
                      iconData: Icons.color_lens_outlined,
                      topText: 'Style and appearance',
                      bottomText: 'Theme, icons and lists style'),
                  SettingsListTile(
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CurrencyPage(
                                        updateNotifier: updateNotifier)))
                          },
                      iconData: Icons.monetization_on_outlined,
                      topText: 'Currency',
                      bottomText: currency),
                  SettingsListTile(
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: theme.colorScheme.surface,
                              contentPadding: const EdgeInsets.all(16),
                              content: IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Text(
                                      'Support for other languages coming soon!',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    BudgetronSmallTextButton(
                                        text: 'Ok',
                                        onTap: () => Navigator.pop(context),
                                        isDelete: false)
                                  ],
                                ),
                              ),
                            )),
                    iconData: Icons.language_outlined,
                    topText: 'Language',
                    bottomText: 'English',
                  ),
                ];

                return ListView.separated(
                    itemBuilder: (context, index) {
                      return widgets[index];
                    },
                    separatorBuilder: (context, _) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: HorizontalSeparator(),
                      );
                    },
                    itemCount: widgets.length);
              },
            )));
  }
}

class SettingsListTile extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  final String topText;
  final String? bottomText;

  const SettingsListTile(
      {super.key,
      required this.iconData,
      required this.topText,
      required this.onTap,
      this.bottomText});

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

    final hasBottomText = bottomText != null;
    if (hasBottomText) {
      //FIX should handle text overflow
      textColumn.add(Text(
        bottomText!,
        style: theme.textTheme.labelMedium!
            .apply(color: colorScheme.surfaceContainerHigh),
        // softWrap: false,
        // overflow: TextOverflow.ellipsis,
      ));
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
                  mainAxisAlignment: hasBottomText
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
