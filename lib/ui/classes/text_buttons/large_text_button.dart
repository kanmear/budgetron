import 'package:flutter/material.dart';

class BudgetronLargeTextButton extends StatelessWidget {
  final List<Listenable> listenables;
  final Function isActive;
  final Function onTap;
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;

  const BudgetronLargeTextButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
    required this.textStyle,
    required this.isActive,
    required this.listenables,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            visualDensity: VisualDensity.compact),
        onPressed: () => _resolveAction(),
        child: AnimatedBuilder(
          animation: Listenable.merge(listenables),
          builder: (BuildContext context, Widget? child) {
            Color buttonColor = _resolveColor(context);

            return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 13.5,
                  bottom: 13.5,
                ),
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border(
                        top: BorderSide(color: buttonColor),
                        bottom: BorderSide(color: buttonColor),
                        left: BorderSide(color: buttonColor),
                        right: BorderSide(color: buttonColor))),
                child: Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ));
          },
        ));
  }

  _resolveAction() => isActive() ? onTap() : {};

  Color _resolveColor(BuildContext context) =>
      isActive() ? backgroundColor : Theme.of(context).colorScheme.outline;
}

//TODO remove this one in favor of LargeButton
class BudgetronBigTextButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;

  const BudgetronBigTextButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
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
                      border: Border(
                          top: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          bottom: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          left: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          right: BorderSide(
                              color: Theme.of(context).colorScheme.primary))),
                  child: Text(
                    text,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  )),
            ),
          ],
        ));
  }
}
