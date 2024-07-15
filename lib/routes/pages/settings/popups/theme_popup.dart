import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';

class ThemeDialog extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final AppData appData;

  const ThemeDialog(
      {super.key, required this.themeNotifier, required this.appData});

  @override
  Widget build(BuildContext context) {
    return DockedDialog(
        title: 'App theme',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThemeRadioButton(
                themeNotifier: themeNotifier,
                themeMode: ThemeMode.light,
                appData: appData),
            const SizedBox(height: 8),
            ThemeRadioButton(
              themeNotifier: themeNotifier,
              themeMode: ThemeMode.dark,
              appData: appData,
            ),
            const SizedBox(height: 8),
            ThemeRadioButton(
              themeNotifier: themeNotifier,
              themeMode: ThemeMode.system,
              appData: appData,
            ),
          ],
        ));
  }
}

class ThemeRadioButton extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final ThemeMode themeMode;

  final AppData appData;

  const ThemeRadioButton(
      {super.key,
      required this.themeNotifier,
      required this.themeMode,
      required this.appData});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, selectedTheme, _) {
        return InkWell(
          onTap: () {
            if (themeMode != themeNotifier.value) _changeTheme(themeMode);
          },
          child: Padding(
            //FIX these paddings inflate tapping are, but also shift buttons
            // further from the popup title
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                Radio(
                  groupValue: selectedTheme,
                  value: themeMode,
                  onChanged: (value) => _changeTheme(value!),
                  activeColor: themeData.colorScheme.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                ),
                const SizedBox(width: 6),
                Text(_capitalize(themeMode.name),
                    style: themeData.textTheme.bodyMedium),
              ],
            ),
          ),
        );
      },
    );
  }

  //REFACTOR
  String _capitalize(String text) {
    return "${text[0].toUpperCase()}${text.substring(1)}";
  }

  void _changeTheme(ThemeMode themeMode) {
    themeNotifier.value = themeMode;
    appData.setThemeMode(themeMode);
  }
}
