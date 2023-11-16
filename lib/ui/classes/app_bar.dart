import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';

class BudgetronAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget leading;
  final String title;

  const BudgetronAppBar(
      {super.key, required this.leading, required this.title});

  @override
  State<BudgetronAppBar> createState() => _BudgetronAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BudgetronAppBarState extends State<BudgetronAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: widget.leading,
      leadingWidth: 48,
      title: Text(widget.title, style: BudgetronFonts.nunitoSize18Weight600),
      titleSpacing: 0,
      toolbarHeight: 48,
    );
  }
}
