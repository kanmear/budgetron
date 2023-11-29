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
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(animation),
            child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0.75, 0.0),
                        end: const Offset(0.0, 0.0))
                    .animate(animation),
                // CurvedAnimation(parent: _controller, curve: Curves.easeIn),
                child: child),
          );
        },
        child: Text(widget.title,
            style: BudgetronFonts.nunitoSize18Weight600,
            key: ValueKey<String>(widget.title)),
      ),
      titleSpacing: 0,
      toolbarHeight: 48,
    );
  }
}
