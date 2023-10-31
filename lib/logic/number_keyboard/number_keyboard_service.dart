import 'package:flutter/widgets.dart';

import 'package:budgetron/ui/classes/keyboard/number_keyboard.dart';

class NumberKeyboardService {
  static const int maxValueLength = 15;

  final ValueNotifier<MathOperation> currentOperation;
  final TextEditingController textController;
  final bool isValueNegative;

  NumberKeyboardService(
      this.textController, this.currentOperation, this.isValueNegative);

  appendDigit(String symbol) {
    String value = textController.text;

    if (value.length <= maxValueLength) {
      if (_isEmptyWithLeadingZero() && !_containsDecimalSeparator()) {
        deleteSymbol();
      }
      textController.text += symbol;
    }
  }

  appendZero() {
    if (_containsDecimalSeparator() || !_isEmptyWithLeadingZero()) {
      appendDigit('0');
    }
  }

  deleteSymbol() {
    String value = textController.text;

    if (value.isEmpty) return;

    if (value[value.length - 1] == ' ') {
      // operation cancel case
      textController.text = value.substring(0, value.length - 3);
      currentOperation.value = MathOperation.none;
    } else {
      textController.text = value.substring(0, value.length - 1);

      if (isValueNegative && textController.text.isEmpty) {
        textController.text = '-';
      }
    }
  }

  appendDecimalSeparator() {
    if (_containsDecimalSeparator()) return;

    if (_isValueEmpty()) {
      textController.text += '0.';
    } else {
      textController.text += '.';
    }
  }

  appendOperation(MathOperation operation, String symbol) {
    if (_isValueEmpty()) return;

    if (currentOperation.value == MathOperation.none) {
      currentOperation.value = operation;
      textController.text += ' $symbol ';
    }
  }

  bool isValueInvalid(double originalValue) {
    String currentValue = textController.text;
    bool isEmpty = currentValue.isEmpty || currentValue == '-';
    if (isEmpty) return true;

    double currentValueDouble = isEmpty ? 0 : double.parse(currentValue);
    return currentValueDouble == 0 || currentValueDouble == originalValue;
  }

  bool isOperationInvalid() {
    String textValue = textController.text;
    String secondOperand =
        textValue.substring(textValue.indexOf(' ') + 3, textValue.length);
    return secondOperand.isEmpty || double.parse(secondOperand) == 0;
  }

  performOperation() {}

  bool _isValueEmpty() {
    String value = textController.text;
    return value.isEmpty || (value.length == 1 && isValueNegative);
  }

  bool _containsDecimalSeparator() {
    return textController.text.contains('.');
  }

  bool _isEmptyWithLeadingZero() {
    return _isValueEmpty()
        ? false
        : textController.text[(isValueNegative ? 1 : 0)] == '0';
  }

  String _getCurrentOperand() {
    String value = textController.text;
    return currentOperation.value == MathOperation.none
        ? value.substring(0, value.indexOf(' '))
        : value.substring(value.indexOf(' ') + 3, value.length);
  }
}
