import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';

class DockedDialog extends StatelessWidget {
  final String title;
  final Widget body;

  const DockedDialog({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      contentPadding:
          const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 14),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: BudgetronFonts.nunitoSize18Weight600),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close),
                //TODO dismiss keyboard with FocusManager.instance.primaryFocus?.unfocus()
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 24),
          body,
        ]),
      ),
    );
  }
}
