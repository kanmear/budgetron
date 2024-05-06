import 'package:flutter/material.dart';

//NOTE is not used anywhere
class ExpenseCheckbox extends StatefulWidget {
  final ValueNotifier<bool> valueNotifier;

  const ExpenseCheckbox({super.key, required this.valueNotifier});
  @override
  State<ExpenseCheckbox> createState() => _ExpenseCheckboxState();
}

class _ExpenseCheckboxState extends State<ExpenseCheckbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      } else {
        return Colors.blue;
      }
    }

    return Checkbox(
      value: isChecked,
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
          widget.valueNotifier.value = isChecked;
        });
      },
    );
  }
}
