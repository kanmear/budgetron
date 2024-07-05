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

  Color _resolveColor(ThemeData theme) => isActive()
      ? theme.colorScheme.secondary
      : theme.colorScheme.secondary.withOpacity(0.2);

  TextStyle _resolveStyle(ThemeData theme) {
    final color = theme.colorScheme.onPrimary;

    return isActive()
        ? theme.textTheme.titleMedium!.apply(color: color)
        : theme.textTheme.titleMedium!.apply(color: color.withOpacity(0.2));
  }
}

//TODO remove this one in favor of LargeButton
class BudgetronBigTextButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color backgroundColor;

  const BudgetronBigTextButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            visualDensity: VisualDensity.compact),
        onPressed: () => onTap(),
        child: Row(
          children: [
            Expanded(
              child: Container(
                  constraints: const BoxConstraints(minWidth: 126),
                  padding: const EdgeInsets.only(
                    top: 13.5,
                    bottom: 13.5,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Text(
                    text,
                    style: theme.textTheme.titleMedium!
                        .apply(color: theme.colorScheme.onPrimary),
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        ));
  }
}
