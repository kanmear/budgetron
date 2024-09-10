import 'package:flutter/material.dart';

class CustomEntryListTile extends StatelessWidget {
  final Widget leadingIcon;
  final String leadingString;
  final Widget leadingOption;

  final String trailingString;

  const CustomEntryListTile({
    super.key,
    required this.leadingIcon,
    required this.leadingString,
    this.leadingOption = const SizedBox(),
    required this.trailingString,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //FIX hardcoded list tile margins sum value
    //REFACTOR calculate once in the Main
    final listTileWidth = (MediaQuery.of(context).size.width - 32).floor();
    final leftPartWidth = listTileWidth / 3 * 2;
    final rightPartWidth = listTileWidth / 3;

    return Container(
      decoration: BoxDecoration(
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
              //FIX hardcoded edge insets sum value
              width: rightPartWidth - 24,
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
