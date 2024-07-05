import 'package:flutter/material.dart';

import 'package:budgetron/logic/number_keyboard/number_keyboard_service.dart';

import 'number_keyboard_keys.dart';

class BudgetronNumberKeyboard extends StatefulWidget {
  final TextEditingController textController;
  final NumberKeyboardService keyboardService;
  final ValueNotifier<MathOperation> currentOperationNotifier;

  const BudgetronNumberKeyboard({
    super.key,
    required this.textController,
    required this.keyboardService,
    required this.currentOperationNotifier,
  });

  @override
  State<BudgetronNumberKeyboard> createState() =>
      _BudgetronNumberKeyboardState();
}

class _BudgetronNumberKeyboardState extends State<BudgetronNumberKeyboard> {
  @override
  Widget build(BuildContext context) {
    final keyboardService = widget.keyboardService;

    double keyHeight = 50;

    final colorScheme = Theme.of(context).colorScheme;
    Color leftPartColor = colorScheme.surfaceContainerLow;
    Color rightPartColor = Theme.of(context).colorScheme.surfaceContainerLowest;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Positioned.fill(
            child: Row(children: [
              Flexible(
                  flex: 3,
                  child: Container(
                      decoration: BoxDecoration(
                          color: leftPartColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8))))),
              Flexible(
                  child: Container(
                      decoration: BoxDecoration(
                          color: rightPartColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8))))),
            ]),
          ),
          Column(children: [
            SizedBox(
              height: keyHeight,
              child: Row(
                children: [
                  BudgetronKeyboardCharKey(
                      char: '1', onTap: () => keyboardService.appendDigit('1')),
                  BudgetronKeyboardCharKey(
                      char: '2', onTap: () => keyboardService.appendDigit('2')),
                  BudgetronKeyboardCharKey(
                      char: '3', onTap: () => keyboardService.appendDigit('3')),
                  BudgetronKeyboardCharKey(
                      char: '×',
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
                      char: '4', onTap: () => keyboardService.appendDigit('4')),
                  BudgetronKeyboardCharKey(
                      char: '5', onTap: () => keyboardService.appendDigit('5')),
                  BudgetronKeyboardCharKey(
                      char: '6', onTap: () => keyboardService.appendDigit('6')),
                  BudgetronKeyboardCharKey(
                      char: '–',
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
                      char: '7', onTap: () => keyboardService.appendDigit('7')),
                  BudgetronKeyboardCharKey(
                      char: '8', onTap: () => keyboardService.appendDigit('8')),
                  BudgetronKeyboardCharKey(
                      char: '9', onTap: () => keyboardService.appendDigit('9')),
                  BudgetronKeyboardCharKey(
                      char: '+',
                      onTap: () => keyboardService.appendOperation(
                          MathOperation.add, '+'))
                ],
              ),
            ),
            SizedBox(
              height: keyHeight,
              child: Row(
                children: [
                  BudgetronKeyboardIconKey(
                      icon: Icon(Icons.keyboard_backspace,
                          color: Theme.of(context).colorScheme.primary),
                      onTap: () => keyboardService.deleteSymbol()),
                  BudgetronKeyboardCharKey(
                      char: '0', onTap: () => keyboardService.appendZero()),
                  BudgetronKeyboardCharKey(
                      char: '.',
                      onTap: () => keyboardService.appendDecimalSeparator()),
                  BudgetronKeyboardOperateKey(
                    textEditingController: widget.textController,
                    operationNotifier: widget.currentOperationNotifier,
                    keyboardService: keyboardService,
                  )
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }
}

enum MathOperation { none, multiply, subtract, add }
