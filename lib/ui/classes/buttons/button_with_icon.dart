import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final Function onTap;
  final Text text;
  final Icon icon;
  final Color backgroundColor;

  const ButtonWithIcon(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.text,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [text, icon],
        ),
      ),
    );
  }
}
