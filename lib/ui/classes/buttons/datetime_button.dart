import 'package:flutter/material.dart';

class DateTimeButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final IconData iconData;

  const DateTimeButton(
      {super.key,
      required this.onTap,
      required this.iconData,
      required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onTap(),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(iconData, color: theme.colorScheme.surfaceContainerHigh),
          const SizedBox(width: 4),
          Text(text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
