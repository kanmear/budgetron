import 'package:flutter/material.dart';

import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/ui/classes/switch_with_text.dart';
import 'package:budgetron/logic/account/account_service.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/color_and_name_selector.dart';
import 'package:budgetron/ui/classes/text_fields/text_field.dart';
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
    final theme = Theme.of(context);

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
                  style: theme.textTheme.labelSmall)),
          const SizedBox(height: 4),
          ColorAndNameSelector(
              textController: nameTextController,
              colorNotifier: colorNotifier,
              hintText: 'Enter account name'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Balance', style: theme.textTheme.labelSmall),
          ),
          const SizedBox(height: 4),
          CustomTextField(
              textController: balanceTextController,
              hintText: '',
              autoFocus: false,
              onSubmitted: (value) => {},
              inputType: TextInputType.number),
          const SizedBox(height: 24),
          BudgetronSwitchWithText(
              switchNotifier: defaultNotifier,
              text: 'Set this account as default'),
          const SizedBox(height: 16),
          BudgetronLargeTextButton(
              text: 'Save account',
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onTap: () => _updateAccount(context),
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
    var balance = double.tryParse(balanceTextController.text);
    if (balance == null) return false;

    Color originalColor = CategoryService.stringToColor(account.color);

    return (nameTextController.text != account.name &&
            nameTextController.text.isNotEmpty) ||
        balance != account.balance ||
        colorNotifier.value != originalColor ||
        defaultNotifier.value != account.isDefault;
  }
}
