import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';
import 'package:budgetron/ui/data/fonts.dart';

import 'number_keyboard.dart';

class BudgetronKeyboardKey extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final Color color;

  const BudgetronKeyboardKey(
      {super.key,
      required this.child,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(color: color),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class BudgetronKeyboardCharKey extends StatelessWidget {
  final Function onTap;
  final String value;
  final Color color;

  const BudgetronKeyboardCharKey(
      {super.key,
      required this.value,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return BudgetronKeyboardKey(
        onTap: onTap,
        color: color,
        child: Text(
          value,
          style: BudgetronFonts.robotoSize30Weight400White,
        ));
  }
}

class BudgetronKeyboardIconKey extends StatelessWidget {
  final Function onTap;
  final Color color;
  final Icon icon;

  const BudgetronKeyboardIconKey(
      {super.key,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BudgetronKeyboardKey(onTap: onTap, color: color, child: icon);
  }
}

class BudgetronKeyboardConfirmKey extends StatelessWidget {
  final ValueListenable<MathOperation> currentOperation;
  final TextEditingController textEditingController;
  final NumberKeyboardService keyboardService;
  final Function isSubmitAvailable;
  final Function onConfirmAction;
  final Function onOperateAction;

  const BudgetronKeyboardConfirmKey(
      {super.key,
      required this.textEditingController,
      required this.currentOperation,
      required this.onConfirmAction,
      required this.onOperateAction,
      required this.keyboardService,
      required this.isSubmitAvailable});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([textEditingController, currentOperation]),
        builder: (context, _) {
          if (currentOperation.value == MathOperation.none) {
            if (isSubmitAvailable(keyboardService)) {
              return BudgetronKeyboardIconKey(
                icon: const Icon(Icons.check, color: Colors.white),
                color: Theme.of(context).colorScheme.secondary,
                onTap: () => _submitChanges(context),
              );
            } else {
              return BudgetronKeyboardIconKey(
                icon: const Icon(Icons.check, color: Colors.white),
                color: Theme.of(context).colorScheme.outline,
                onTap: () => {},
              );
            }
          } else {
            return BudgetronKeyboardCharKey(
                value: '=',
                color: Theme.of(context).colorScheme.primary,
                onTap: () => onOperateAction());
          }
        });
  }

  _submitChanges(BuildContext context) {
    //REFACTOR textEditingController being passed here is wrong
    onConfirmAction(textEditingController.text);
    Navigator.pop(context);
  }
}
