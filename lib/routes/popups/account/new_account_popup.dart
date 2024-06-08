import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/ui/classes/switch_with_text.dart';
import 'package:budgetron/logic/account/account_service.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/color_and_name_selector.dart';
import 'package:budgetron/ui/classes/text_fields/small_text_field.dart';
import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';

class NewAccountDialog extends StatelessWidget {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController balanceTextController =
      TextEditingController(text: '0');
  final ValueNotifier<Color?> colorNotifier = ValueNotifier(null);
  final ValueNotifier<bool> defaultNotifier = ValueNotifier(false);

  NewAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DockedDialog(
        title: 'New Account',
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Color and account name',
                  style: BudgetronFonts.nunitoSize16Weight400)),
          const SizedBox(height: 4),
          ColorAndNameSelector(
              textController: nameTextController,
              colorNotifier: colorNotifier,
              hintText: 'Enter account name'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Balance', style: BudgetronFonts.nunitoSize16Weight400),
          ),
          const SizedBox(height: 4),
          //TODO onTap => clean zero?
          BudgetronSmallTextField(
              textController: balanceTextController,
              hintText: '',
              autoFocus: false,
              onSubmitted: () => {},
              inputType: TextInputType.number),
          const SizedBox(height: 24),
          BudgetronSwitchWithText(
              switchNotifier: defaultNotifier,
              text: 'Set this account as default'),
          const SizedBox(height: 16),
          BudgetronLargeTextButton(
              text: 'Create account',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () => _addAccount(context),
              textStyle: BudgetronFonts.nunitoSize18Weight500White,
              isActive: _isValid,
              listenables: [
                nameTextController,
                balanceTextController,
                colorNotifier
              ])
        ]));
  }

  void _addAccount(BuildContext context) {
    String color = CategoryService.colorToString(colorNotifier.value!);
    double balance = double.parse(balanceTextController.text);
    bool isDefault = defaultNotifier.value;

    Account account = Account(
        name: nameTextController.text,
        color: color,
        balance: balance,
        isDefault: isDefault);

    AccountService.createAccount(account);
    Navigator.pop(context);
  }

  bool _isValid() =>
      nameTextController.text.isNotEmpty &&
      balanceTextController.text.isNotEmpty &&
      colorNotifier.value != null;
}
