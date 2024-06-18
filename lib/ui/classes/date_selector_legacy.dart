import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/enums/date_period.dart';

class LegacyDateSelector extends StatelessWidget {
  const LegacyDateSelector({super.key, required this.datePeriodNotifier});

  final ValueNotifier<DatePeriod> datePeriodNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          //TODO set a shadow
          // boxShadow: [
          //   BoxShadow(
          //       color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 12,
          //       offset: const Offset(0, -3))
          // ]
        ),
        height: 56,
        child: DatePeriodSelector(datePeriodNotifier: datePeriodNotifier));
  }
}

class DatePeriodSelector extends StatefulWidget {
  const DatePeriodSelector({super.key, required this.datePeriodNotifier});

  final ValueNotifier<DatePeriod> datePeriodNotifier;

  @override
  State<DatePeriodSelector> createState() => _DatePeriodSelectorState();
}

class _DatePeriodSelectorState extends State<DatePeriodSelector> {
  var items = [DatePeriod.day, DatePeriod.month];
  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: DropdownButton(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            value: widget.datePeriodNotifier.value,
            items: items.map((DatePeriod period) {
              return DropdownMenuItem<DatePeriod>(
                  value: period, child: _dateSelectorItem(period));
            }).toList(),
            selectedItemBuilder: (BuildContext context) =>
                _dateSelectorDisplayedItem(context),
            onChanged: (DatePeriod? value) => _selectDatePeriod(value),
            underline: const SizedBox(),
            icon: const SizedBox()));
  }

  _dateSelectorItem(DatePeriod period) {
    return Row(children: [
      const SizedBox(width: 8),
      Text(period.toString(), style: BudgetronFonts.nunitoSize16Weight400)
    ]);
  }

  _dateSelectorDisplayedItem(BuildContext context) {
    var color = Theme.of(context).colorScheme.surface;

    return items.map((period) {
      return Align(
          alignment: Alignment.center,
          child: Row(children: [
            //HACK invisible icons to inflate width of menu button
            Icon(Icons.check_box_outline_blank, color: color),
            Text(_resolveTextValue(),
                style: BudgetronFonts.nunitoSize16Weight400),
            const Icon(Icons.arrow_drop_down),
            Icon(Icons.check_box_outline_blank, color: color)
          ]));
    }).toList();
  }

  String _resolveTextValue() => widget.datePeriodNotifier.value.toString();

  _selectDatePeriod(DatePeriod? value) =>
      setState(() => widget.datePeriodNotifier.value = value!);
}
