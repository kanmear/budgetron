// Autogenerated from Pigeon (v10.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

abstract class BudgetAPI {
  static const MessageCodec<Object?> codec = StandardMessageCodec();

  void resetBudget(int budgetId);

  static void setup(BudgetAPI? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.BudgetAPI.resetBudget', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.BudgetAPI.resetBudget was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final int? arg_budgetId = (args[0] as int?);
          assert(arg_budgetId != null,
              'Argument for dev.flutter.pigeon.BudgetAPI.resetBudget was null, expected non-null int.');
          api.resetBudget(arg_budgetId!);
          return;
        });
      }
    }
  }
}
