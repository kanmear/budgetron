import 'package:budgetron/globals.dart' as globals;
import 'package:budgetron/utils/date_utils.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/models/enums/date_period.dart';

class DateSelector extends StatelessWidget {
  const DateSelector(
      {super.key,
      required this.datePeriodNotifier,
      required this.dateTimeNotifier});

  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Theme.of(context).colorScheme.surface,
      child: DatePeriodSelector(
        datePeriodNotifier: datePeriodNotifier,
        dateTimeNotifier: dateTimeNotifier,
      ),
    );
  }
}

class DatePeriodSelector extends StatefulWidget {
  const DatePeriodSelector(
      {super.key,
      required this.datePeriodNotifier,
      required this.dateTimeNotifier});

  final ValueNotifier<List<DateTime>> dateTimeNotifier;
  final ValueNotifier<DatePeriod> datePeriodNotifier;

  @override
  State<DatePeriodSelector> createState() => _DatePeriodSelectorState();
}

class _DatePeriodSelectorState extends State<DatePeriodSelector> {
  var items = [DatePeriod.month, DatePeriod.year];
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
          items: items.map((DatePeriod period) {
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
    return Row(children: [
      const SizedBox(width: 8),
      Text(DatePeriodMap.getName(period),
          style: BudgetronFonts.nunitoSize16Weight400)
    ]);
  }

  _dateSelectorDisplayedItem(BuildContext context) {
    var color = Theme.of(context).colorScheme.surface;

    return items.map((period) {
      return Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            //HACK invisible icons to inflate width of menu button
            Icon(Icons.check_box_outline_blank, color: color),
            Text(_resolveTextValue(),
                style: BudgetronFonts.nunitoSize16Weight400),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
            Icon(Icons.check_box_outline_blank, color: color),
          ],
        ),
      );
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

    DateTime earliestDate = globals.earliestEntryDate;

    if (isMonth) {
      return value > 0
          ? (wouldBeDate.month + value <= now.month)
          : (wouldBeDate.month + value >= earliestDate.month);
    } else {
      //year period
      return value > 0
          ? (wouldBeDate.year + value <= now.year)
          : (wouldBeDate.year + value >= earliestDate.year);
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

class ArrowIcon extends StatelessWidget {
  const ArrowIcon(
      {super.key,
      required this.onTap,
      required this.isEnabled,
      required this.iconData});

  final Function onTap;
  final bool isEnabled;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => isEnabled ? onTap() : {},
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(iconData, color: _resolveColor(context, isEnabled))));
  }

  Color _resolveColor(BuildContext context, bool isEnabled) {
    var colorScheme = Theme.of(context).colorScheme;
    return isEnabled ? colorScheme.primary : colorScheme.outline;
  }
}
