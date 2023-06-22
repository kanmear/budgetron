import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/ui/icons.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';

class BudgetronAppBarWithTabs extends StatelessWidget {
  final ValueNotifier<EntryCategoryType> tabNotifier;
  final Row tabs;

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
            const ArrowBackIconButton(),
            tabs,
            //TODO find a way to properly center
            const SizedBox(width: 48 /* width of iconButton */),
          ],
        ),
      ),
    );
  }
}

class BudgetronTopBarTab extends StatelessWidget {
  final ValueNotifier<Enum> tabNotifier;
  final Enum associatedTabValue;
  final Function onTapAction;
  final EdgeInsets padding;
  final String name;

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
                            color: tabNotifier.value == associatedTabValue
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent))),
                child: Text(name, style: BudgetronFonts.nunitoSize16Weight400),
              );
            }),
      ),
    );
  }
}
