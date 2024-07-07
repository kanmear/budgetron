import 'package:flutter/material.dart';

class BudgetronLargeTextButton extends StatelessWidget {
  final List<Listenable> listenables;
  final Function isActive;
  final Function onTap;
  final String text;
  final Color backgroundColor;

  const BudgetronLargeTextButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
    required this.isActive,
    required this.listenables,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            visualDensity: VisualDensity.compact),
        onPressed: () => _resolveAction(),
        child: AnimatedBuilder(
          animation: Listenable.merge(listenables),
          builder: (BuildContext context, Widget? child) {
            final theme = Theme.of(context);

            Color buttonColor = _resolveColor(theme);

            return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 13.5,
                  bottom: 13.5,
                ),
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                child: Text(
                  text,
                  style: _resolveStyle(theme),
                  textAlign: TextAlign.center,
                ));
          },
        ));
  }

  _resolveAction() => isActive() ? onTap() : {};

  Color _resolveColor(ThemeData theme) =>
      isActive() ? backgroundColor : backgroundColor.withOpacity(0.2);

  TextStyle _resolveStyle(ThemeData theme) {
    final color = theme.colorScheme.onPrimary;

    return isActive()
        ? theme.textTheme.titleMedium!.apply(color: color)
        : theme.textTheme.titleMedium!.apply(color: color.withOpacity(0.2));
  }
}
