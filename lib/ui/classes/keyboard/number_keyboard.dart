import 'package:flutter/material.dart';

import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';

import 'number_keyboard_keys.dart';

class BudgetronNumberKeyboard extends StatelessWidget {
  final ValueNotifier<MathOperation> currentOperation =
      ValueNotifier(MathOperation.none);
  final TextEditingController textController;
  final Function isSubmitAvailable;
  final Function onConfirmAction;

  static const double ratio = 0.8;

  BudgetronNumberKeyboard(
      {super.key,
      required this.textController,
      required this.onConfirmAction,
      required this.isSubmitAvailable});

  @override
  Widget build(BuildContext context) {
    final NumberKeyboardService keyboardService =
        NumberKeyboardService(textController, currentOperation);

    double keyHeight = MediaQuery.of(context).size.width / 4.0 * ratio;
    Color mainKeyColor = Theme.of(context).colorScheme.tertiary;
    Color secondaryKeyColor = Theme.of(context).colorScheme.primary;

    return Column(children: [
      SizedBox(
        height: keyHeight,
        child: Row(
          children: [
            BudgetronKeyboardCharKey(
                value: '1',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDigit('1')),
            BudgetronKeyboardCharKey(
                value: '2',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDigit('2')),
            BudgetronKeyboardCharKey(
                value: '3',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDigit('3')),
            BudgetronKeyboardCharKey(
                value: '×',
                color: secondaryKeyColor,
                onTap: () => keyboardService.appendOperation(
                    MathOperation.multiply, '×'))
          ],
        ),
      ),
      SizedBox(
        height: keyHeight,
        child: Row(
          children: [
            BudgetronKeyboardCharKey(
                value: '4',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDigit('4')),
            BudgetronKeyboardCharKey(
                value: '5',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDigit('5')),
            BudgetronKeyboardCharKey(
                value: '6',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDigit('6')),
            BudgetronKeyboardCharKey(
                value: '–',
                color: secondaryKeyColor,
                onTap: () => keyboardService.appendOperation(
                    MathOperation.subtract, '–'))
          ],
        ),
      ),
      SizedBox(
        height: keyHeight,
        child: Row(
          children: [
            BudgetronKeyboardCharKey(
                value: '7',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDigit('7')),
            BudgetronKeyboardCharKey(
                value: '8',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDigit('8')),
            BudgetronKeyboardCharKey(
                value: '9',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDigit('9')),
            BudgetronKeyboardCharKey(
                value: '+',
                color: secondaryKeyColor,
                onTap: () =>
                    keyboardService.appendOperation(MathOperation.add, '+'))
          ],
        ),
      ),
      SizedBox(
        height: keyHeight,
        child: Row(
          children: [
            BudgetronKeyboardIconKey(
                icon: const Icon(Icons.keyboard_backspace, color: Colors.white),
                color: mainKeyColor,
                onTap: () => keyboardService.deleteSymbol()),
            BudgetronKeyboardCharKey(
                value: '0',
                color: mainKeyColor,
                onTap: () => keyboardService.appendZero()),
            BudgetronKeyboardCharKey(
                value: '.',
                color: mainKeyColor,
                onTap: () => keyboardService.appendDecimalSeparator()),
            BudgetronKeyboardConfirmKey(
              textEditingController: textController,
              currentOperation: currentOperation,
              onConfirmAction: onConfirmAction,
              onOperateAction: () => keyboardService.performOperation(),
              keyboardService: keyboardService,
              isSubmitAvailable: isSubmitAvailable,
            )
          ],
        ),
      ),
    ]);
  }
}

enum MathOperation { none, multiply, subtract, add }
