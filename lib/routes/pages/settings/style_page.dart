import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/app_data.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/ui/classes/horizontal_separator.dart';

import 'package:budgetron/routes/pages/settings/popups/theme_popup.dart';
import 'package:budgetron/routes/pages/settings/widgets/tile_with_popup.dart';

class StylePage extends StatelessWidget {
  const StylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BudgetronAppBar(
        leading: ArrowBackIconButton(),
        title: 'Style and appearance',
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: StyleSettings(),
      ),
    );
  }
}

class StyleSettings extends StatelessWidget {
  const StyleSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final themeNotifier = ValueNotifier<ThemeMode>(appData.themeMode);

    final widgets = [
      TileWithPopup(
        title: 'Theme',
        valueNotifier: themeNotifier,
        popup: ThemeDialog(themeNotifier: themeNotifier, appData: appData),
      ),
      DateModeSelector()
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
  }
}

//REFACTOR should be extracted as generic TileWithSwitch or something
class DateModeSelector extends StatefulWidget {
  final ValueNotifier<bool> switchNotifier = ValueNotifier(false);

  DateModeSelector({super.key});

  @override
  State<DateModeSelector> createState() => _DateModeSelectorState();
}

class _DateModeSelectorState extends State<DateModeSelector> {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);
    final theme = Theme.of(context);

    widget.switchNotifier.value = appData.legacyDateSelector;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Use legacy lists view',
            style: theme.textTheme.bodyMedium,
          ),
          //FIX handle text overflow
          SizedBox(
            width: 250,
            child: Text(
                'Legacy puts all entries on one page and groups them by date',
                softWrap: true,
                style: theme.textTheme.labelMedium!
                    .apply(color: theme.colorScheme.surfaceContainerHigh)),
          ),
        ],
      ),
      Switch(
          onChanged: (bool value) {
            setState(() => widget.switchNotifier.value = value);
            appData.setLegacyDateSelector(value);
          },
          value: widget.switchNotifier.value,
          activeColor: Theme.of(context).colorScheme.secondary)
    ]);
  }
}
