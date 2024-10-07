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
          //NOTE 3 and 2 flex factors feel like magic
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
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
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: Text(
              trailingString,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
