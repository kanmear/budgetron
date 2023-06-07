import 'package:flutter/material.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';

class BudgetronAppBarWithTabs extends StatelessWidget {
  final Row tabs;
  final ValueNotifier<bool> tabNotifier;

  const BudgetronAppBarWithTabs(
      {super.key, required this.tabNotifier, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      //TODO find universally correct solution for status bar
      padding: const EdgeInsets.only(top: 38.0),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new)),
            tabs,
            //TODO find a way to properly center
            const SizedBox(width: 48 /* width of iconButton */),
          ],
        ),
      ),
    );
  }
}

//TODO move to separate folder
class BudgetronTopBarTab extends StatelessWidget {
  final ValueNotifier<bool> tabNotifier;
  final Function onTapAction;
  final EdgeInsets padding;
  final String name;
  final bool associatedTabValue;

  const BudgetronTopBarTab({
    super.key,
    required this.tabNotifier,
    required this.onTapAction,
    required this.padding,
    required this.name,
    required this.associatedTabValue,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapAction(),
      child: Padding(
        padding: padding,
        child: ValueListenableBuilder(
            valueListenable: tabNotifier,
            builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            //TODO universal solution needed for any number of tabs
                            color: tabNotifier.value == associatedTabValue
                                ? BudgetronColors.gray1
                                : Colors.transparent))),
                child: Text(name, style: BudgetronFonts.nunitoSize16Weight400),
              );
            }),
      ),
    );
  }
}
