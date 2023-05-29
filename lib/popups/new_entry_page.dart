import 'package:budgetron/ui/button_styles.dart';
import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/ui/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewEntryPage extends StatelessWidget {
  NewEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [PseudoAppBar(), EntryValueTextField(), DateAndCategoryRow()],
    ));
  }
}

class DateAndCategoryRow extends StatelessWidget {
  const DateAndCategoryRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 21),
      child: SizedBox(
        //FIXME: hardcoded height in order for divider to work
        height: 47,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            DateField(),
            VerticalDivider(
              width: 0,
              thickness: 1,
              color: BudgetronColors.gray1,
            ),
            CategoryField()
          ],
        ),
      ),
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
        child: Center(
            child: Column(
      children: [
        Text("Category", style: BudgetronFonts.nunitoSize14Weight400),
        const SizedBox(height: 6),
        TextButton(
            style: BudgetronButtonStyles.textButtonStyle,
            onPressed: () => {},
            child: Text(
              "Choose",
              style: BudgetronFonts.nunitoSize16Weight600Unused,
            ))
      ],
    )));
  }
}

class DateField extends StatelessWidget {
  const DateField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    )));
  }
}

class EntryValueTextField extends StatelessWidget {
  const EntryValueTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 36.0, right: 36.0),
          child: TextField(
            onTapOutside: (event) {},
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(Radius.zero)),
                focusedBorder: OutlineInputBorder(
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
  const PseudoAppBar({
    super.key,
  });

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
                TextButton(
                    style: BudgetronButtonStyles.textButtonStyle,
                    onPressed: () => {},
                    child: Text("Income",
                        style: BudgetronFonts.nunitoSize16Weight400)),
                const SizedBox(width: 30),
                TextButton(
                    style: BudgetronButtonStyles.textButtonStyle,
                    onPressed: () => {},
                    child: Text("Spendings",
                        style: BudgetronFonts.nunitoSize16Weight400)),
              ],
            ),
            const SizedBox(width: 48 /* same size as iconButton */),
          ],
        ),
      ),
    );
  }
}
