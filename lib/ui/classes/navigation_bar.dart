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
    return Container(
        height: 72,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 12,
                  offset: const Offset(0, -3))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            navigationIconButton(const Icon(Icons.list), 0, context),
            navigationIconButton(const Icon(Icons.home), 1, context),
            middleButton(context),
            navigationIconButton(const Icon(Icons.wallet), 2, context),
            navigationIconButton(const Icon(Icons.bar_chart), 3, context),
          ],
        ));
  }

  IconButton navigationIconButton(
          Icon icon, int iconIndex, BuildContext context) =>
      IconButton(
        onPressed: () => selectPage(iconIndex),
        icon: icon,
        color: isCurrentlySelected(iconIndex)
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.tertiary,
      );

  InkWell middleButton(BuildContext context) => InkWell(
      onTap: () => navigateToEntryCreation(context),
      child: Icon(Icons.add_circle_outlined,
          size: 50, color: Theme.of(context).colorScheme.surface));
}
