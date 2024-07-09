import 'package:flutter/material.dart';

class CustomIconPath {
  static const String entriesPage = "assets/icons/nav_bar/entries_page.svg";
  static const String homePage = "assets/icons/nav_bar/home_page.svg";
  static const String budgetsPage = "assets/icons/nav_bar/budgets_page.svg";
  static const String statsPage = "assets/icons/nav_bar/stats_page.svg";
}

//TODO naming
class ArrowBackIconButton extends StatelessWidget {
  const ArrowBackIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios_new),
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}

//TODO use whenever instead of inplace widgets
class CustomIconButton extends StatelessWidget {
  final Function onTap;
  final Icon icon;

  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => onTap(), child: icon);
  }
}

//TODO rename to drawerIcon?
class MenuIconButton extends StatelessWidget {
  //TODO replace iconButton with custom InkWell impl for a rectangular hitbox
  final Function onTap;

  const MenuIconButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onTap(),
      icon: const Icon(Icons.menu),
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
