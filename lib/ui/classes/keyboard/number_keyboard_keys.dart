import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';
import 'package:budgetron/ui/data/fonts.dart';

import 'number_keyboard.dart';

class BudgetronKeyboardKey extends StatelessWidget {
  final Function onTap;
  final Widget child;

  const BudgetronKeyboardKey(
      {super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(),
        child: Center(child: child),
      ),
    );
  }
}

class BudgetronKeyboardCharKey extends StatelessWidget {
  final Function onTap;
  final String char;

  const BudgetronKeyboardCharKey({
    super.key,
    required this.char,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BudgetronKeyboardKey(
        onTap: onTap,
        child: Text(
          char,
          style: BudgetronFonts.robotoSize24Weight400,
        ));
  }
}

class BudgetronKeyboardIconKey extends StatelessWidget {
  final Function onTap;
  final Icon icon;

  const BudgetronKeyboardIconKey({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BudgetronKeyboardKey(onTap: onTap, child: icon);
  }
}

class BudgetronKeyboardOperateKey extends StatelessWidget {
  final ValueListenable<MathOperation> operationNotifier;
  final TextEditingController textEditingController;
  final NumberKeyboardService keyboardService;

  const BudgetronKeyboardOperateKey({
    super.key,
    required this.textEditingController,
    required this.operationNotifier,
    required this.keyboardService,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([textEditingController, operationNotifier]),
        builder: (context, _) {
          final isOperationActive =
              operationNotifier.value != MathOperation.none;

          if (isOperationActive) {
            return BudgetronKeyboardKey(
                onTap: () => keyboardService.performOperation(),
                child: Text('=', style: BudgetronFonts.robotoSize24Weight400));
          } else {
            return BudgetronKeyboardKey(
                onTap: () => {},
                child: Text('=',
                    style: BudgetronFonts.robotoSize24Weight400Disabled));
          }
        });
  }
}
