import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/buttons/button_with_icon.dart';

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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        padding: EdgeInsets.zero,
        child: ValueListenableBuilder(
          valueListenable: timeNotifier,
          builder: (context, timeValue, _) {
            return ButtonWithIcon(
                onTap: () => _selectTime(context),
                icon: const Icon(Icons.access_time),
                color: Theme.of(context).colorScheme.background,
                text: "${timeValue.hour}:${timeValue.minute}");
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
        context: context,
        initialTime: currentTime);

    if (time != null && time != currentTime) {
      timeNotifier.value = time;
    }

    isKeyboardOnNotifier.value = true;
  }
}
