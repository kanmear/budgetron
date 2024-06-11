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

class EditAccountDialog extends StatelessWidget {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController balanceTextController =
      TextEditingController(text: '0');
  final ValueNotifier<Color?> colorNotifier = ValueNotifier(null);
  final ValueNotifier<bool> defaultNotifier = ValueNotifier(false);

  final Account account;

  EditAccountDialog({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final originalName = account.name;
    nameTextController.text = originalName;

    final originalBalance = account.balance;
    balanceTextController.text = originalBalance.toStringAsFixed(2);

    final originalColor = CategoryService.stringToColor(account.color);
    colorNotifier.value = originalColor;

    final originalIsDefault = account.isDefault;
    defaultNotifier.value = originalIsDefault;

    return DockedDialog(
        title: 'Edit Account',
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
              text: 'Save account',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () => _updateAccount(context),
              textStyle: BudgetronFonts.nunitoSize18Weight500White,
              isActive: _isValid,
              listenables: [
                nameTextController,
                balanceTextController,
                colorNotifier,
                defaultNotifier
              ])
        ]));
  }

  void _updateAccount(BuildContext context) {
    String balance = balanceTextController.text;
    account.balance = balance.isNotEmpty ? double.parse(balance) : 0;

    account.name = nameTextController.text;
    account.color = CategoryService.colorToString(colorNotifier.value!);
    account.isDefault = defaultNotifier.value;

    AccountService.updateAccount(account);
    Navigator.pop(context);
  }

  bool _isValid() {
    Color originalColor = CategoryService.stringToColor(account.color);

    return (nameTextController.text != account.name &&
            nameTextController.text.isNotEmpty) ||
        double.parse(balanceTextController.text.isEmpty
                ? '0'
                : balanceTextController.text) !=
            account.balance ||
        colorNotifier.value != originalColor ||
        defaultNotifier.value != account.isDefault;
  }
}
