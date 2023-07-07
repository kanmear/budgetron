import 'package:flutter/material.dart';

class ArrowBackIconButton extends StatelessWidget {
  const ArrowBackIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new));
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

class MenuIconButton extends StatelessWidget {
  //TODO replace iconButton with custom InkWell impl for a rectangular hitbox
  const MenuIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => {/* add impl */}, icon: const Icon(Icons.menu));
  }
}
