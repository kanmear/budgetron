import 'package:budgetron/ui/fonts.dart';
import 'package:flutter/material.dart';

class BudgetronDropdownButton extends StatefulWidget {
  final ValueNotifier<Object?> valueNotifier;
  final Future<List<Object>> items;
  final Function? leading;
  final String hint;

  const BudgetronDropdownButton(
      {super.key,
      this.leading,
      required this.items,
      required this.hint,
      required this.valueNotifier});

  @override
  State<BudgetronDropdownButton> createState() =>
      _BudgetronDropdownButtonState();
}

class _BudgetronDropdownButtonState extends State<BudgetronDropdownButton> {
  @override
  initState() {
    super.initState();
    widget.valueNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        height: 38,
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        child: FutureBuilder(
            future: widget.items,
            builder: (BuildContext context,
                AsyncSnapshot<List<Object>> dropdownItems) {
              if (dropdownItems.data?.isNotEmpty ?? false) {
                return DropdownButton(
                    value: widget.valueNotifier.value,
                    hint: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(widget.hint,
                            style: BudgetronFonts.nunitoSize16Weight400Hint),
                      ],
                    ),
                    underline: const SizedBox(),
                    isExpanded: true,
                    items: dropdownItems.data!.map((Object o) {
                      return DropdownMenuItem<Object>(
                        value: o.toString(),
                        child: Row(children: [
                          const SizedBox(width: 8),
                          if (widget.leading != null) widget.leading!(o),
                          Text(o.toString(),
                              style: BudgetronFonts.nunitoSize16Weight400)
                        ]),
                      );
                    }).toList(),
                    icon: const SizedBox(
                      height: 31,
                      width: 31,
                      child: Icon(Icons.arrow_drop_down),
                    ),
                    onChanged: (Object? value) {
                      setState(() {
                        widget.valueNotifier.value = value!;
                      });
                    });
              } else {
                return const Text("No data");
              }
            }));
  }
}
