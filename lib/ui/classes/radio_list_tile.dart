import 'package:budgetron/ui/data/fonts.dart';
import 'package:flutter/material.dart';

class BudgetronRadioListTile extends StatelessWidget {
  final String label;
  final EdgeInsets padding;

  final Function onChanged;
  final Enum groupValue;
  final value;

  const BudgetronRadioListTile(
      {super.key,
      required this.label,
      required this.groupValue,
      required this.value,
      required this.onChanged,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) onChanged(value);
      },
      child: Padding(
        padding: padding,
        child: Row(children: [
          Radio(
            groupValue: groupValue,
            value: value,
            onChanged: (value) => onChanged(value),
            activeColor: Theme.of(context).colorScheme.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
          ),
          const SizedBox(width: 4),
          Text(label, style: BudgetronFonts.nunitoSize16Weight400)
        ]),
      ),
    );
  }
}
