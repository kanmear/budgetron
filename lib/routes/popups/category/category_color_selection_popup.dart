import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/text_buttons/large_text_button.dart';
import 'package:budgetron/ui/data/fonts.dart';

class CategoryColorDialog extends StatelessWidget {
  final List<List<Color>> colors = const [
    [
      Color(0xffF44336),
      Color(0xffE91E63),
      Color(0xff9C27B0),
      Color(0xff673AB7),
      Color(0xff3F51B5),
      Color(0xff2196F3),
    ],
    [
      Color(0xffEF9A9A),
      Color(0xffF48FB1),
      Color(0xffCE93D8),
      Color(0xffB39DDB),
      Color(0xff9FA8DA),
      Color(0xff90CAF9)
    ],
    [
      Color(0xff00BCD4),
      Color(0xff009688),
      Color(0xff4CAF50),
      Color(0xff8BC34A),
      Color(0xffCDDC39),
      Color(0xffFFEB3B),
    ],
    [
      Color(0xff80DEEA),
      Color(0xff80CBC4),
      Color(0xffA5D6A7),
      Color(0xffC5E1A5),
      Color(0xffE6EE9C),
      Color(0xffFFF59D),
    ],
    [
      Color(0xffFFC107),
      Color(0xffFF9800),
      Color(0xffFF5722),
      Color(0xff795548),
      Color(0xff607D8B),
      Color(0xff608b6e),
    ],
    [
      Color(0xffFFE082),
      Color(0xffFFCC80),
      Color(0xffFFAB91),
      Color(0xffBCAAA4),
      Color(0xffB0BEC5),
      Color(0xffb0c5b7),
    ]
  ];

  const CategoryColorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<MapEntry<int, int>> colorNotifier =
        ValueNotifier(const MapEntry(-1, -1));

    return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        insetPadding: const EdgeInsets.all(30),
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          height: 280,
          width: double.maxFinite,
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category color",
                        style: BudgetronFonts.nunitoSize18Weight600,
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
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
                Expanded(
                  child: BudgetronLargeTextButton(
                    text: "Confirm",
                    onTap: () => _validateColorIsChosen(context, colorNotifier),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textStyle: BudgetronFonts.nunitoSize16Weight400Confirm,
                    isActive: () => _isValid(colorNotifier),
                    listenables: [colorNotifier],
                  ),
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

  void _validateColorIsChosen(BuildContext context,
          ValueNotifier<MapEntry<int, int>> colorNotifier) =>
      Navigator.pop(
          context, colors[colorNotifier.value.key][colorNotifier.value.value]);

  bool _isValid(ValueNotifier<MapEntry<int, int>> colorNotifier) =>
      colorNotifier.value.key != -1 && colorNotifier.value.value != -1;
}
