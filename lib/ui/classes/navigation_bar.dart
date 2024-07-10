import 'package:budgetron/ui/classes/icons/custom_icon.dart';
import 'package:budgetron/ui/data/colors.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:flutter/material.dart';

class BudgetronNavigationBar extends StatelessWidget {
  final Function selectPage;
  final Function isCurrentlySelected;
  final Function navigateToEntryCreation;

  const BudgetronNavigationBar(
      {super.key,
      required this.selectPage,
      required this.isCurrentlySelected,
      required this.navigateToEntryCreation});

  @override
  Widget build(BuildContext context) {
    const color = BudgetronColors.lightPrimary;

    return Container(
        height: 88,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.only(left: 16, right: 16),
        decoration: const BoxDecoration(color: color),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            navigationIconButton(CustomIconPath.entriesPage, 0),
            navigationIconButton(CustomIconPath.homePage, 1),
            middleButton(context),
            navigationIconButton(CustomIconPath.budgetsPage, 2),
            navigationIconButton(CustomIconPath.statsPage, 3),
          ],
        ));
  }

  Widget navigationIconButton(String iconPath, int pageIndex) {
    const backgroundColor = BudgetronColors.lightPrimary;
    Color splashColor = BudgetronColors.white.withOpacity(0.05);

    return SizedBox(
      height: 48,
      width: 48,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          splashColor: splashColor,
          highlightColor: splashColor,
          customBorder: const CircleBorder(),
          onTap: () => selectPage(pageIndex),
          child: CustomIcon(
              iconPath: iconPath,
              color: isCurrentlySelected(pageIndex)
                  ? BudgetronColors.white
                  : BudgetronColors.darkSurface4),
        ),
      ),
    );
  }

  InkWell middleButton(BuildContext context) => InkWell(
      onTap: () => navigateToEntryCreation(context),
      child: const Icon(Icons.add_circle_outlined,
          size: 52, color: BudgetronColors.white));
}
