import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/classes/buttons/datetime_button.dart';

class BudgetronTimeButton extends StatelessWidget {
  final ValueNotifier<bool> isKeyboardOnNotifier;
  final ValueNotifier<TimeOfDay> timeNotifier;

  const BudgetronTimeButton(
      {super.key,
      required this.timeNotifier,
      required this.isKeyboardOnNotifier});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.zero,
        child: ValueListenableBuilder(
          valueListenable: timeNotifier,
          builder: (context, timeValue, _) {
            var hour = timeValue.hour.toString().padLeft(2, '0');
            var minute = timeValue.minute.toString().padLeft(2, '0');

            return DateTimeButton(
              onTap: () => _selectTime(context),
              iconData: Icons.access_time,
              text: "$hour:$minute",
            );
          },
        ),
      ),
    );
  }

  void _selectTime(BuildContext context) async {
    isKeyboardOnNotifier.value = false;

    var currentTime = timeNotifier.value;

    final TimeOfDay? time = await showTimePicker(
        // initialEntryMode: TimePickerEntryMode.dialOnly,
        builder: (context, child) {
          final themeMode = Provider.of<AppData>(context).themeMode;

          return Theme(
            data: themeMode == ThemeMode.light
                ? ThemeData.light()
                : ThemeData.dark(),
            child: child!,
          );
          // final theme = Theme.of(context);
          // final colorScheme = theme.colorScheme;
          //
          // return Theme(
          //     data: ThemeData.light().copyWith(
          //         timePickerTheme: TimePickerThemeData(
          //       backgroundColor: colorScheme.surface, // Background color
          //       hourMinuteColor: colorScheme.surfaceContainerLow,
          //       hourMinuteTextColor:
          //           colorScheme.primary, // Text color for hours and minutes
          //       dayPeriodColor: colorScheme.tertiary,
          //       dayPeriodTextColor: colorScheme.primary, // Text color for AM/PM
          //       dialBackgroundColor: colorScheme.surfaceContainerLow,
          //       dialHandColor: colorScheme.tertiary,
          //       dialTextColor:
          //           colorScheme.primary, // Text color on the clock dial
          //       entryModeIconColor: colorScheme.surfaceContainerHigh,
          //       helpTextStyle: theme.textTheme.bodyMedium,
          //       cancelButtonStyle: ButtonStyle(
          //           textStyle: WidgetStateProperty.resolveWith(
          //               (states) => theme.textTheme.bodyMedium),
          //           foregroundColor:
          //               WidgetStateProperty.all<Color>(colorScheme.primary)),
          //       confirmButtonStyle: ButtonStyle(
          //           textStyle: WidgetStateProperty.resolveWith(
          //               (states) => theme.textTheme.bodyMedium),
          //           foregroundColor:
          //               WidgetStateProperty.all<Color>(colorScheme.primary)),
          //       hourMinuteTextStyle: theme.textTheme
          //           .displayMedium, // Text style for hours and minutes
          //     )),
          //     child: child!);
        },
        context: context,
        initialTime: currentTime);

    if (time != null && time != currentTime) {
      timeNotifier.value = time;
    }

    isKeyboardOnNotifier.value = true;
  }
}
