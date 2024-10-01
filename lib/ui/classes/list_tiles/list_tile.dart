import 'package:flutter/material.dart';

import 'package:budgetron/utils/string_utils.dart';

class CustomListTile extends StatelessWidget {
  final Widget leadingIcon;
  final String leadingString;
  final Widget leadingOption;
  final Decoration? decoration;

  final String trailingString;

  const CustomListTile({
    super.key,
    required this.leadingIcon,
    required this.leadingString,
    this.leadingOption = const SizedBox(),
    this.trailingString = StringUtils.emptyString,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //FIX hardcoded list tile margins sum value (32)
    //FIX hardcoded edge insets sum value (24)
    //REFACTOR calculate once in the Main
    final listTileWidth = (MediaQuery.of(context).size.width - 32 - 24).floor();
    final isTrailingEmpty = trailingString.isEmpty;

    final leftPartWidth =
        isTrailingEmpty ? listTileWidth.toDouble() : listTileWidth / 3 * 2;
    final rightPartWidth = isTrailingEmpty ? 0.toDouble() : listTileWidth / 3;

    return Container(
      height: 48,
      decoration: decoration ??
          BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surfaceContainerLowest),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: leftPartWidth,
            child: Row(
              children: [
                leadingIcon,
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    leadingString,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                leadingOption
              ],
            ),
          ),
          SizedBox(
              width: rightPartWidth,
              child: Text(
                trailingString,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              )),
        ],
      ),
    );
  }
}
