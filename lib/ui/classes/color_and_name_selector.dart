import 'package:flutter/material.dart';

import 'package:budgetron/ui/classes/text_fields/text_field.dart';
import 'package:budgetron/routes/popups/category/category_color_selection_popup.dart';

class ColorAndNameSelector extends StatelessWidget {
  final TextEditingController textController;
  final ValueNotifier<Color?> colorNotifier;
  final String hintText;

  const ColorAndNameSelector(
      {super.key,
      required this.textController,
      required this.colorNotifier,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
          onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      const CategoryColorDialog())
              .then((value) => _setColor(value)),
          child: ValueListenableBuilder(
              valueListenable: colorNotifier,
              builder: (BuildContext context, value, Widget? child) {
                return Container(
                    padding: EdgeInsets.zero,
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                        color: value ?? Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5)),
                    child: value == null ? const Icon(Icons.add) : null);
              })),
      const SizedBox(width: 8),
      Expanded(
          child: CustomTextField(
              textController: textController,
              inputType: TextInputType.text,
              hintText: hintText,
              autoFocus: false,
              onSubmitted: () {}))
    ]);
  }

  void _setColor(Color? value) {
    if (value != null) colorNotifier.value = value;
  }
}
