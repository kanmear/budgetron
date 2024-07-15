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
      behavior: HitTestBehavior.opaque,
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
                //REFACTOR
                String text = value is ThemeMode
                    ? _getThemeModeName(value)
                    : value.toString();

                return Text(text,
                    style: theme.textTheme.labelMedium!
                        .apply(color: theme.colorScheme.surfaceContainerHigh));
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    String modeString = mode.toString();
    int pointIndex = modeString.indexOf('.');
    return _capitalize(modeString.substring(++pointIndex));
  }

  String _capitalize(String text) {
    return "${text[0].toUpperCase()}${text.substring(1)}";
  }
}
