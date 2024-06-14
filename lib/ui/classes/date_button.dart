import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/ui/classes/buttons/button_with_icon.dart';

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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        padding: EdgeInsets.zero,
        child: ValueListenableBuilder(
          valueListenable: dateNotifier,
          builder: (context, dateValue, _) {
            return ButtonWithIcon(
                onTap: () => _selectDate(context),
                icon: const Icon(Icons.calendar_month),
                color: Theme.of(context).colorScheme.background,
                text: DateFormat.yMMMd().format(dateValue));
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
        lastDate: DateTime(2101));

    if (date != null && date != currentDate) {
      dateNotifier.value = date;
    }

    isKeyboardOnNotifier.value = true;
  }
}
