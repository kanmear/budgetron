import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';

class TileWithPopup extends StatelessWidget {
  final ValueNotifier<Object> valueNotifier;
  final String title;
  final Widget popup;

  const TileWithPopup(
      {super.key,
      required this.valueNotifier,
      required this.title,
      required this.popup});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(context: context, builder: (context) => popup),
      child: SizedBox(
        height: 48,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: BudgetronFonts.nunitoSize16Weight400,
            ),
            ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (context, value, _) {
                return Text(
                  value.toString(),
                  style: BudgetronFonts.nunitoSize16Weight300Gray,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
