import 'package:flutter/material.dart';

class BudgetronAppBar extends StatefulWidget implements PreferredSizeWidget {
  const BudgetronAppBar(
      {super.key,
      required this.leading,
      required this.title,
      this.actions = const []});

  final List<Widget> actions;
  final Widget leading;
  final String title;

  @override
  State<BudgetronAppBar> createState() => _BudgetronAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BudgetronAppBarState extends State<BudgetronAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: AppBar(
        leading: widget.leading,
        leadingWidth: 24,
        title: Text(widget.title,
            style: theme.textTheme.headlineLarge,
            overflow: TextOverflow.fade,
            key: ValueKey<String>(widget.title)),
        titleSpacing: 8,
        actions: widget.actions,
        elevation: 0,
        toolbarHeight: 48,
        backgroundColor: theme.colorScheme.surface,
      ),
    );
  }
}
