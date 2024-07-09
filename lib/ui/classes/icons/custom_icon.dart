import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String iconPath;
  final Color color;

  const CustomIcon({super.key, required this.color, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      height: 24,
      width: 24,
      fit: BoxFit.none,
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final String iconPath;
  final Function onTap;
  final Color color;

  const CustomIconButton(
      {super.key,
      required this.iconPath,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: InkWell(
          onTap: () => onTap(),
          child: CustomIcon(iconPath: iconPath, color: color)),
    );
  }
}
