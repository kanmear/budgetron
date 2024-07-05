import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final Function onTap;
  final String text;
  final IconData iconData;

  const ButtonWithIcon(
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.surfaceContainerHigh),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: theme.textTheme.bodyMedium),
            Icon(iconData, color: theme.colorScheme.primary)
          ],
        ),
      ),
    );
  }
}
