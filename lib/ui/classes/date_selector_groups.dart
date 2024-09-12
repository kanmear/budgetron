import 'package:budgetron/utils/date_utils.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/ui/classes/date_selector.dart';

//REFACTOR a lot of similarity with other date selectors
class DateSelectorGroups extends StatelessWidget {
  const DateSelectorGroups(
      {super.key,
      required this.datePeriodNotifier,
      required this.dateTimeNotifier,
      required this.periodItems,
      required this.earliestDate});

  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final List<DatePeriod> periodItems;
  final DateTime earliestDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 56,
      color: theme.colorScheme.surfaceContainerLow,
      child: DatePeriodSelector(
          datePeriodNotifier: datePeriodNotifier,
          dateTimeNotifier: dateTimeNotifier,
          items: periodItems,
          earliestDate: earliestDate),
    );
  }
}

class DatePeriodSelector extends StatefulWidget {
  const DatePeriodSelector(
      {super.key,
      required this.datePeriodNotifier,
      required this.dateTimeNotifier,
      required this.items,
      required this.earliestDate});

  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;
  final List<DatePeriod> items;
  final DateTime earliestDate;

  @override
  State<DatePeriodSelector> createState() => _DatePeriodSelectorState();
}

class _DatePeriodSelectorState extends State<DatePeriodSelector> {
  var now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArrowIcon(
            onTap: () => _selectDate(-1),
            iconData: Icons.arrow_back_ios,
            isEnabled: _resolveEnabled(-1)),
        DropdownButton(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          value: widget.datePeriodNotifier.value,
          items: widget.items.map((DatePeriod period) {
            return DropdownMenuItem<DatePeriod>(
                value: period, child: _dateSelectorItem(period));
          }).toList(),
          selectedItemBuilder: (BuildContext context) =>
              _dateSelectorDisplayedItem(context),
          onChanged: (DatePeriod? value) => _selectDatePeriod(value),
          underline: const SizedBox(),
          icon: const SizedBox(),
        ),
        ArrowIcon(
            onTap: () => _selectDate(1),
            iconData: Icons.arrow_forward_ios,
            isEnabled: _resolveEnabled(1)),
      ],
    );
  }

  _dateSelectorItem(DatePeriod period) {
    final theme = Theme.of(context);

    return Row(children: [
      const SizedBox(width: 8),
      Text(period.toString(), style: theme.textTheme.bodyMedium)
    ]);
  }

  _dateSelectorDisplayedItem(BuildContext context) {
    final theme = Theme.of(context);
    var color = theme.colorScheme.surfaceContainerLow;

    return widget.items.map((period) {
      return Align(
          alignment: Alignment.center,
          child: Row(children: [
            //HACK invisible icons to inflate width of menu button
            Icon(Icons.check_box_outline_blank, color: color),
            Text(_resolveTextValue(), style: theme.textTheme.bodyMedium),
            Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
            Icon(Icons.check_box_outline_blank, color: color)
          ]));
    }).toList();
  }

  String _resolveTextValue() {
    var date = widget.dateTimeNotifier.value[0];

    if (widget.datePeriodNotifier.value == DatePeriod.month) {
      return DateFormat.MMM().format(date);
    } else {
      return DateFormat.y().format(date);
    }
  }

  bool _resolveEnabled(int value) {
    //REFACTOR is it possible to reduce this to 1 call per build?
    var isMonth = widget.datePeriodNotifier.value == DatePeriod.month;
    var wouldBeDate = widget.dateTimeNotifier.value[0];

    if (isMonth) {
      wouldBeDate = DateUtils.addMonthsToMonthDate(wouldBeDate, value);
      var wouldBeShifted = BudgetronDateUtils.shiftToEndOfMonth(wouldBeDate);
      var nowShifted = BudgetronDateUtils.shiftToEndOfMonth(now);
      if (value == 1) {}

      return value > 0
          ? (wouldBeDate.isBefore(nowShifted))
          : (wouldBeShifted.isAfter(widget.earliestDate));
    } else {
      //year period
      return value > 0
          ? (wouldBeDate.year + value <= now.year)
          : (wouldBeDate.year + value >= widget.earliestDate.year);
    }
  }

  _selectDatePeriod(DatePeriod? value) {
    DatePeriod period = value!;

    DateTime fromDate;
    DateTime toDate;
    if (period == DatePeriod.month) {
      fromDate = DateTime(now.year, now.month);
      toDate = BudgetronDateUtils.shiftToEndOfMonth(fromDate);
    } else {
      //year period
      fromDate = DateTime(now.year);
      toDate = BudgetronDateUtils.shiftToEndOfYear(fromDate);
    }

    setState(() {
      widget.datePeriodNotifier.value = period;
      widget.dateTimeNotifier.value = [fromDate, toDate];
    });
  }

  _selectDate(int value) {
    var isMonth = widget.datePeriodNotifier.value == DatePeriod.month;

    var dates = widget.dateTimeNotifier.value;
    var oldFromDate = dates[0];

    DateTime newFromDate;
    DateTime newToDate;

    if (isMonth) {
      newFromDate = DateUtils.addMonthsToMonthDate(oldFromDate, value);
      newToDate = BudgetronDateUtils.shiftToEndOfMonth(newFromDate);
    } else {
      //year period
      newFromDate = DateTime(oldFromDate.year + value);
      newToDate = BudgetronDateUtils.shiftToEndOfYear(newFromDate);
    }

    setState(() {
      widget.dateTimeNotifier.value = [newFromDate, newToDate];
    });
  }
}
