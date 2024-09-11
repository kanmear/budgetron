import 'package:flutter/material.dart';

//REFACTOR rename to budgetron docked dialog for consistency
class DockedDialog extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? keyboard;

  const DockedDialog(
      {super.key, required this.title, required this.body, this.keyboard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    //FIX hardcoded list tile margins sum value (32)
    //REFACTOR calculate once in the Main
    final titleMaxWidth = (screenWidth - 32) / 6 * 5;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      backgroundColor: theme.colorScheme.surface,
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: screenWidth,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding:
                const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: titleMaxWidth,
                        child: Text(
                          title,
                          style: theme.textTheme.headlineLarge,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        )),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 24,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                body
              ],
            ),
          ),
          //REFACTOR instead of null checks can just supply SizedBox when keyboard is not needed
          keyboard ?? const SizedBox()
        ]),
      ),
    );
  }
}
