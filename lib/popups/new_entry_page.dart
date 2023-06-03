import 'package:budgetron/models/category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';

class NewEntryPage extends StatefulWidget {
  //TODO maybe tab should be saved between entries
  final ValueNotifier<int> tabNotifier = ValueNotifier(1);

  NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  EntryCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        PseudoAppBar(tabNotifier: widget.tabNotifier),
        EntryValueTextField(
          tabNotifier: widget.tabNotifier,
        ),
        DateAndCategoryRow()
      ],
    ));
  }
}

class DateAndCategoryRow extends StatelessWidget {
  const DateAndCategoryRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DateField(),
        Container(
          height: 47,
          width: 1,
          decoration: BoxDecoration(
              border: Border.all(color: BudgetronColors.gray1, width: 1)),
        ),
        CategoryField()
      ],
    );
  }
}

class CategoryField extends StatelessWidget {
  const CategoryField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {print("tapped category")},
      child: Padding(
        padding: const EdgeInsets.only(top: 21, bottom: 21),
        child: Center(
            child: Column(
          children: [
            Text("Category", style: BudgetronFonts.nunitoSize14Weight400),
            const SizedBox(height: 6),
            Text(
              "Choose",
              style: BudgetronFonts.nunitoSize16Weight600Unused,
            ),
            // TextButton(
            //     style: BudgetronButtonStyles.textButtonStyle,
            //     onPressed: null,
            //     child: Text(
            //       "Choose",
            //       style: BudgetronFonts.nunitoSize16Weight600Unused,
            //     ))
          ],
        )),
      ),
    ));
  }
}

class DateField extends StatelessWidget {
  const DateField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {print("tapped date")},
      child: Padding(
        padding: const EdgeInsets.only(top: 21, bottom: 21),
        child: Center(
            child: Column(
          children: [
            Text(
              "Date",
              style: BudgetronFonts.nunitoSize14Weight400,
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat.yMMMd().format(DateTime.now()),
              style: BudgetronFonts.nunitoSize16Weight600,
            )
          ],
        )),
      ),
    ));
  }
}

class EntryValueTextField extends StatelessWidget {
  final ValueNotifier<int> tabNotifier;

  const EntryValueTextField({
    super.key,
    required this.tabNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 36.0, right: 36.0),
          child: TextField(
            style: BudgetronFonts.robotoSize32Weight400,
            // onSubmitted: (value) => {/* validate fields and create entry */},
            onSubmitted: (value) => {print(tabNotifier.value)},
            onTapOutside: (event) {},
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    top: 9, bottom: 9, left: 10, right: 10),
                hintStyle: BudgetronFonts.robotoSize32Weight400Hint,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(Radius.zero)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(Radius.zero)),
                hintText: 'Enter value'),
          ),
        ),
      ),
    );
  }
}

class PseudoAppBar extends StatelessWidget {
  final ValueNotifier<int> tabNotifier;

  const PseudoAppBar({super.key, required this.tabNotifier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new)),
            Row(
              children: [
                InkWell(
                  onTap: () => {tabNotifier.value = 1},
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 15, top: 13, bottom: 13),
                    child: ValueListenableBuilder(
                        valueListenable: tabNotifier,
                        builder: (context, value, child) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: tabNotifier.value == 1
                                            ? BudgetronColors.gray1
                                            : Colors.transparent))),
                            child: Text("Expense",
                                style: BudgetronFonts.nunitoSize16Weight400),
                          );
                        }),
                  ),
                ),
                // const SizedBox(width: 30),
                InkWell(
                  onTap: () => {tabNotifier.value = 2},
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 24, top: 13, bottom: 13),
                    child: ValueListenableBuilder(
                        valueListenable: tabNotifier,
                        builder: (context, value, child) {
                          return Container(
                            decoration: BoxDecoration(
                                //FIXME this pads text by 1 vpx
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: tabNotifier.value == 2
                                            ? BudgetronColors.gray1
                                            : Colors.transparent))),
                            child: Text("Income",
                                style: BudgetronFonts.nunitoSize16Weight400),
                          );
                        }),
                  ),
                ),
              ],
            ),
            //TODO find a way to properly center
            const SizedBox(width: 48 /* width of iconButton */),
          ],
        ),
      ),
    );
  }
}
