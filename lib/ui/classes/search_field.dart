import 'package:flutter/material.dart';

class BudgetronSearchField extends StatefulWidget {
  final ValueNotifier<String> filter;
  final String hintText;

  const BudgetronSearchField({
    super.key,
    required this.filter,
    required this.hintText,
  });

  @override
  State<BudgetronSearchField> createState() => _BudgetronSearchFieldState();
}

class _BudgetronSearchFieldState extends State<BudgetronSearchField> {
  late Color iconColor;

  void setIconColor(bool focus) {
    if (focus) {
      setState(() {
        iconColor = Theme.of(context).colorScheme.primary;
      });
    } else if (!focus && widget.filter.value.isEmpty) {
      setState(() {
        iconColor = Theme.of(context).colorScheme.primary.withOpacity(0.2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    iconColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Focus(
        onFocusChange: (focus) => setIconColor(focus),
        child: TextField(
          style: theme.textTheme.headlineMedium,
          cursorColor: theme.colorScheme.primary,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 13, bottom: 13),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary),
                borderRadius: const BorderRadius.all(Radius.circular(2))),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: theme.colorScheme.primary, width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(2))),
            hintText: widget.hintText,
            hintStyle: theme.textTheme.headlineMedium!
                .apply(color: theme.colorScheme.surfaceContainerHigh),
            prefixIconConstraints: const BoxConstraints(),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                  right: 8, left: 12, top: 12, bottom: 12),
              child: Transform.scale(
                scaleX: -1,
                child: Icon(Icons.search, color: iconColor),
              ),
            ),
          ),
          onChanged: (value) => {widget.filter.value = value},
        ),
      ),
    );
  }
}
