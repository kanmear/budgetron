import 'package:flutter/material.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';

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
  Color iconColor = BudgetronColors.gray4;

  void setIconColor(bool focus) {
    if (focus) {
      setState(() {
        iconColor = BudgetronColors.black;
      });
    } else if (!focus && widget.filter.value.isEmpty) {
      setState(() {
        iconColor = BudgetronColors.gray4;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Focus(
        onFocusChange: (focus) => setIconColor(focus),
        child: TextField(
          style: BudgetronFonts.nunitoSize16Weight600,
          cursorColor: BudgetronColors.black,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 13, bottom: 13),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: BudgetronColors.black),
                borderRadius: BorderRadius.all(Radius.circular(2))),
            focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: BudgetronColors.black, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(2))),
            hintText: widget.hintText,
            hintStyle: BudgetronFonts.nunitoSize16Weight600Hint,
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
