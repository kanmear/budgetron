import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/text_button.dart';
import 'package:budgetron/ui/data/fonts.dart';

class CategoryColorDialog extends StatelessWidget {
  final List<List<Color>> colors = const [
    [Colors.amber, Colors.orange, Colors.yellow, Colors.yellowAccent],
    [Colors.red, Colors.pink, Colors.brown, Colors.redAccent],
    [Colors.green, Colors.teal, Colors.cyan, Colors.lightGreen],
    [Colors.amber, Colors.orange, Colors.yellow, Colors.yellowAccent],
    [Colors.red, Colors.pink, Colors.brown, Colors.redAccent],
    [Colors.green, Colors.teal, Colors.cyan, Colors.lightGreen]
  ];

  const CategoryColorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<MapEntry<int, int>> colorNotifier =
        ValueNotifier(const MapEntry(-1, -1));

    return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        insetPadding: const EdgeInsets.all(30),
        contentPadding:
            const EdgeInsets.only(top: 24, bottom: 16, left: 20, right: 20),
        content: SizedBox(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category color",
                    style: BudgetronFonts.nunitoSize18Weight600,
                  ),
                  Text(
                    "Colors used by existing categories *",
                    style: BudgetronFonts.nunitoSize11Weight300,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: colorNotifier,
                    builder: (context, value, child) {
                      return ListView(shrinkWrap: true, children: [
                        for (int i = 0; i < colors.length; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int j = 0; j < colors[i].length; j++)
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () =>
                                        _selectColor(i, j, colorNotifier),
                                    icon: Icon(
                                      (colorNotifier.value.key == i &&
                                              colorNotifier.value.value == j)
                                          ? Icons.circle_outlined
                                          : Icons.circle,
                                      color: colors[i][j],
                                      size: 48,
                                    ))
                            ],
                          )
                      ]);
                    })),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BudgetronTextButton(
                  text: "Cancel",
                  onTap: () => {Navigator.pop(context)},
                  backgroundColor: Theme.of(context).colorScheme.background,
                  textStyle: BudgetronFonts.nunitoSize16Weight400,
                ),
                BudgetronTextButton(
                  text: "Confirm",
                  onTap: () => _validateColorIsChosen(context, colorNotifier),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: BudgetronFonts.nunitoSize16Weight400Confirm,
                ),
              ],
            )
          ]),
        ));
  }

  void _selectColor(
      int i, int j, ValueNotifier<MapEntry<int, int>> colorNotifier) {
    colorNotifier.value = MapEntry(i, j);
  }

  void _validateColorIsChosen(
      BuildContext context, ValueNotifier<MapEntry<int, int>> colorNotifier) {
    if (colorNotifier.value.key == -1 || colorNotifier.value.value == -1) {
      //TODO add validation message
      return;
    }

    Navigator.pop(
        context, colors[colorNotifier.value.key][colorNotifier.value.value]);
  }
}
