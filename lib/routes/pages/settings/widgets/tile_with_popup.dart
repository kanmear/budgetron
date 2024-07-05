import 'package:flutter/material.dart';

class TileWithPopup extends StatelessWidget {
  final ValueNotifier<Object> valueNotifier;
  final String title;
  final Widget popup;

  const TileWithPopup(
      {super.key,
      required this.valueNotifier,
      required this.title,
      required this.popup});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => showDialog(context: context, builder: (context) => popup),
      child: SizedBox(
        height: 48,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
            ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (context, value, _) {
                return Text(value.toString(),
                    style: theme.textTheme.labelMedium!
                        .apply(color: theme.colorScheme.surfaceContainerHigh));
              },
            ),
          ],
        ),
      ),
    );
  }
}
