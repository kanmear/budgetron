import 'package:flutter/material.dart';

class BudgetronRadioListTile extends StatelessWidget {
  final String label;
  final EdgeInsets padding;

  final Function onChanged;
  final Enum groupValue;
  final Object value;

  const BudgetronRadioListTile(
      {super.key,
      required this.label,
      required this.groupValue,
      required this.value,
      required this.onChanged,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            activeColor: theme.colorScheme.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
          ),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.bodyMedium)
        ]),
      ),
    );
  }
}
