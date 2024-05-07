import 'package:flutter/material.dart';

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

class EditIconButton extends StatelessWidget {
  const EditIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => {/* add impl */}, icon: const Icon(Icons.edit));
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
