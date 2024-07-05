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
        padding: EdgeInsets.zero,
        child: ValueListenableBuilder(
          valueListenable: timeNotifier,
          builder: (context, timeValue, _) {
            var hour = timeValue.hour.toString().padLeft(2, '0');
            var minute = timeValue.minute.toString().padLeft(2, '0');

            return ButtonWithIcon(
                onTap: () => _selectTime(context),
                iconData: Icons.access_time,
                text: "$hour:$minute");
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
