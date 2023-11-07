import 'package:flutter/material.dart';

//TODO rename to DeleteIconButton and move to icon_buttons folder
class DeleteButton extends StatelessWidget {
  final Function onTap;

  const DeleteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: const BorderRadius.all(Radius.circular(3))),
        height: 48,
        width: 48,
        child: IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () => onTap(),
        ));
  }
}
