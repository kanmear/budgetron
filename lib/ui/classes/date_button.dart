import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/classes/buttons/datetime_button.dart';

class BudgetronDateButton extends StatelessWidget {
  final ValueNotifier<bool> isKeyboardOnNotifier;
  final ValueNotifier<DateTime> dateNotifier;

  const BudgetronDateButton(
      {super.key,
      required this.dateNotifier,
      required this.isKeyboardOnNotifier});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.zero,
        child: ValueListenableBuilder(
          valueListenable: dateNotifier,
          builder: (context, dateValue, _) {
            return DateTimeButton(
              onTap: () => _selectDate(context),
              iconData: Icons.calendar_month,
              text: DateFormat.yMMMd().format(dateValue),
            );
          },
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    isKeyboardOnNotifier.value = false;

    var currentDate = dateNotifier.value;

    final DateTime? date = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (context, child) {
          final themeMode = Provider.of<AppData>(context).themeMode;

          return Theme(
            data: themeMode == ThemeMode.light
                ? ThemeData.light()
                : ThemeData.dark(),
            child: child!,
          );
          // return Theme(
          //     data: ThemeData.light().copyWith(
          //         datePickerTheme: DatePickerThemeData(
          //       dayBackgroundColor: WidgetStateColor.resolveWith(
          //         (Set<WidgetState> states) {
          //           return states.contains(WidgetState.selected)
          //               ? colorScheme.tertiary
          //               : Colors.transparent;
          //         },
          //       ),
          //       dayOverlayColor: WidgetStateProperty.resolveWith(
          //           (states) => colorScheme.tertiary),
          //       dayForegroundColor: WidgetStateProperty.resolveWith(
          //           (states) => colorScheme.primary),
          //       weekdayStyle: theme.textTheme.bodyMedium!
          //           .apply(color: colorScheme.primary),
          //       yearForegroundColor: WidgetStateProperty.resolveWith(
          //           (states) => colorScheme.primary),
          //       yearStyle: theme.textTheme.bodyMedium!
          //           .apply(color: theme.colorScheme.primary),
          //       yearOverlayColor: WidgetStateProperty.resolveWith(
          //           (states) => colorScheme.primary),
          //       rangePickerHeaderForegroundColor: colorScheme.primary,
          //       todayBackgroundColor: WidgetStateProperty.resolveWith(
          //           (states) => colorScheme.tertiary.withOpacity(0.2)),
          //       todayForegroundColor: WidgetStateProperty.resolveWith(
          //           (states) => colorScheme.primary),
          //       todayBorder: const BorderSide(color: Colors.transparent),
          //       backgroundColor: colorScheme.surface,
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
          //       headerHelpStyle: theme.textTheme.bodyMedium,
          //       headerForegroundColor: colorScheme.primary,
          //       headerHeadlineStyle: theme.textTheme.bodyMedium,
          //     )),
          //     child: child!);
        });

    if (date != null && date != currentDate) {
      dateNotifier.value = date;
    }

    isKeyboardOnNotifier.value = true;
  }
}
