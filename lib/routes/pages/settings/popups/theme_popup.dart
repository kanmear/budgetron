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
                theme: ThemeMode.light,
                appData: appData),
            const SizedBox(height: 24),
            ThemeRadioButton(
              themeNotifier: themeNotifier,
              theme: ThemeMode.dark,
              appData: appData,
            ),
          ],
        ));
  }
}

class ThemeRadioButton extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier;
  final ThemeMode theme;

  final AppData appData;

  const ThemeRadioButton(
      {super.key,
      required this.themeNotifier,
      required this.theme,
      required this.appData});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, selectedTheme, _) {
        return Row(
          children: [
            Radio(
              groupValue: selectedTheme,
              value: theme,
              onChanged: (value) => _changeTheme(value!),
              activeColor: themeData.colorScheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
            ),
            const SizedBox(width: 6),
            Text(theme.name, style: themeData.textTheme.bodyMedium),
          ],
        );
      },
    );
  }

  void _changeTheme(ThemeMode themeMode) {
    themeNotifier.value = themeMode;
    appData.setThemeMode(themeMode);
  }
}
