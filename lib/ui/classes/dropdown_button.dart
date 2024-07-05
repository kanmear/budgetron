import 'package:flutter/material.dart';

class BudgetronDropdownButton extends StatefulWidget {
  //REFACTOR is it possible to not use valuenotifier?
  final ValueNotifier<Object?> valueNotifier;
  final Future<List<Object>> items;
  final Function? leading;
  final String fallbackValue;
  final String hint;

  const BudgetronDropdownButton(
      {super.key,
      this.leading,
      required this.items,
      required this.hint,
      required this.valueNotifier,
      required this.fallbackValue});

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
    final theme = Theme.of(context);

    return Container(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        height: 38,
        decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.surfaceContainerHigh),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        child: FutureBuilder(
            //REFACTOR why is future builder used for static values?
            future: widget.items,
            builder: (BuildContext context,
                AsyncSnapshot<List<Object>> dropdownItems) {
              if (dropdownItems.data?.isNotEmpty ?? false) {
                return DropdownButton(
                    //TODO limit max size of dropdown item container
                    //FIX selected item isn't highlighted
                    // menuMaxHeight: 260,
                    value: widget.valueNotifier.value,
                    hint: Row(
                      children: [
                        const SizedBox(width: 8),
                        Text(widget.hint,
                            style: theme.textTheme.bodyMedium!.apply(
                                color: theme.colorScheme.surfaceContainerHigh)),
                      ],
                    ),
                    underline: const SizedBox(),
                    isExpanded: true,
                    items: dropdownItems.data!.map((Object object) {
                      return DropdownMenuItem<Object>(
                        value: object,
                        child: Row(children: [
                          const SizedBox(width: 8),
                          //REFACTOR this is a weird way to do this
                          if (widget.leading != null) widget.leading!(object),
                          Text(object.toString(),
                              style: theme.textTheme.bodyMedium)
                        ]),
                      );
                    }).toList(),
                    icon: SizedBox(
                      height: 31,
                      width: 31,
                      child: Icon(Icons.arrow_drop_down,
                          color: theme.colorScheme.primary),
                    ),
                    onChanged: (Object? value) {
                      setState(() {
                        widget.valueNotifier.value = value!;
                      });
                    });
              } else {
                return Container(
                    padding: const EdgeInsets.only(left: 8),
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.fallbackValue,
                          style: theme.textTheme.bodyMedium!.apply(
                              color: theme.colorScheme.surfaceContainerHigh)),
                    ));
              }
            }));
  }
}
