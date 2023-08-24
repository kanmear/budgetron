import 'package:budgetron/models/entry.dart';
import 'package:flutter/material.dart';

class EntryService {
  static void formEntriesData(List<Entry> data,
      Map<DateTime, List<Entry>> entriesMap, List<DateTime> entryDates) {
    for (var element in data) {
      _addEntryToMap(entriesMap, element);
    }

    entryDates.addAll(entriesMap.keys.toList());
    entryDates.sort(((a, b) => b.compareTo(a)));
    //TODO is this approach optimal?
  }

  static void _addEntryToMap(
      Map<DateTime, List<Entry>> entriesMap, Entry entry) {
    DateTime dateTime =
        DateTime(entry.dateTime.year, entry.dateTime.month, entry.dateTime.day);

    if (entriesMap.containsKey(dateTime)) {
      List<Entry> currentEntries = entriesMap[dateTime]!;

      // if an entry with the same category exists - update that entry
      int sameCategoryEntry = currentEntries.indexWhere((element) =>
          element.category.target!.name == entry.category.target!.name);
      if (sameCategoryEntry != -1) {
        Entry updatedEntry = currentEntries[sameCategoryEntry];
        updatedEntry.value += entry.value;
        updatedEntry.value =
            double.parse(updatedEntry.value.toStringAsFixed(2));
        currentEntries[sameCategoryEntry] = updatedEntry;
      }

      // if category is unique for that date - add as a separate row
      else {
        entriesMap.update(
            dateTime, (value) => List.from(value)..addAll({entry}));
      }
    } else {
      entriesMap[dateTime] = List.from({entry});
    }
  }

  //TODO move to budgetService?
  static List<DateTime> getDatePeriod(String period, {DateTime? end}) {
    end ??= DateTime.now();
    DateTime start;

    switch (period) {
      case 'Month':
        start = DateTime(end.year, end.month);
        break;
      case 'Week':
        start = _getPastMonday(end);
        break;
      case 'Two weeks':
        start = _getPastMonday(end, weekMultiplier: 2);
        break;
      case 'Six months':
        start = DateUtils.addMonthsToMonthDate(end, -6);
        break;
      case 'Year':
        start = DateTime(end.year);
        break;
      default:
        start = end;
    }

    return [start, end];
  }

  static DateTime _getPastMonday(DateTime weekStart, {int weekMultiplier = 1}) {
    while (weekStart.weekday != 1) {
      weekStart = DateUtils.addDaysToDate(weekStart, -1);
    }

    return DateUtils.addDaysToDate(weekStart, (--weekMultiplier * -7));
  }
}
