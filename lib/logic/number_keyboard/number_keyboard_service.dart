import 'package:flutter/widgets.dart';

import 'package:budgetron/ui/classes/keyboard/number_keyboard.dart';

class NumberKeyboardService {
  static const int maxValueLength = 8;

  final ValueNotifier<MathOperation> currentOperation;
  final TextEditingController textController;
  final Function isValueNegative;

  NumberKeyboardService(
      this.textController, this.currentOperation, this.isValueNegative);

  appendDigit(String symbol) {
    String value = _getCurrentOperand();

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

      if (isValueNegative() && textController.text.isEmpty) {
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
    if (_isValueEmpty() || double.parse(_getCurrentOperand()) == 0) return;

    if (currentOperation.value == MathOperation.none) {
      currentOperation.value = operation;
      textController.text += ' $symbol ';
    } else {
      currentOperation.value = operation;
      String text = textController.text;
      int operationIndex = text.indexOf(' ') + 1;
      textController.text =
          text.replaceRange(operationIndex, operationIndex + 1, symbol);
    }
  }

  /*
  Checks if entry value changes can be submitted:
  empty field, zero or the same value are not valid.
   */
  bool isValueUpdateValid(double originalValue) {
    String currentValue = _getValue();
    bool isEmpty = currentValue.isEmpty;
    if (isEmpty) return false;

    double currentValueDouble = double.parse(currentValue);
    return !(currentValueDouble == 0 || currentValueDouble == originalValue);
  }

  /*
  Checks if new entry value is valid: empty field or zero are not valid values.
   */
  bool isValueValidForCreation() {
    String currentValue = _getValue();
    bool isEmpty = currentValue.isEmpty;
    if (isEmpty) return false;

    return double.parse(currentValue) != 0;
  }

  performOperation() {
    if (_isOperationInvalid()) {
      String value = textController.text;
      textController.text = value.substring(0, value.indexOf(' '));
      currentOperation.value = MathOperation.none;
      return;
    }

    String textValue = _getValue();
    int separatingPointIndex = textValue.indexOf(' ');
    double firstOperand =
        double.parse(textValue.substring(0, separatingPointIndex)) *
            (isValueNegative() ? -1 : 1);
    double secondOperand = double.parse(
        textValue.substring(separatingPointIndex + 3, textValue.length));

    textController.text = _resolveExpressionValue(firstOperand, secondOperand);
    currentOperation.value = MathOperation.none;
  }

  bool _isOperationInvalid() {
    String textValue = _getValue();
    String secondOperand =
        textValue.substring(textValue.indexOf(' ') + 3, textValue.length);
    return secondOperand.isEmpty || double.parse(secondOperand) == 0;
  }

  bool _isValueEmpty() => _getCurrentOperand().isEmpty;

  bool _containsDecimalSeparator() => _getCurrentOperand().contains('.');

  bool _isEmptyWithLeadingZero() =>
      _isValueEmpty() ? false : _getCurrentOperand()[0] == '0';

  String _getCurrentOperand() {
    String value = _getValue();
    String currentOperand = currentOperation.value == MathOperation.none
        ? value
        : value.substring(value.indexOf(' ') + 3, value.length);
    // print('Current operand: $currentOperand');
    //TODO FIX this is being called way too often
    return currentOperand;
  }

  String _getValue() {
    String value = textController.text;
    if (value.isEmpty) return value;

    return isValueNegative() ? value.substring(1) : value;
  }

  String _resolveExpressionValue(double x, double y) {
    double value;
    switch (currentOperation.value) {
      case MathOperation.multiply:
        value = x * y;
        break;
      case MathOperation.subtract:
        value = x - y;
        break;
      case MathOperation.add:
        value = x + y;
        break;
      default:
        throw Exception('Not a possible operation value');
    }

    // changing sign of a value should not be possible
    if (value > 0 && isValueNegative()) {
      value = -0;
    } else if (value < 0 && !isValueNegative()) {
      value = 0;
    }

    return value.toStringAsFixed(2);
  }
}
