import 'package:budgetron/models/entry.dart';

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

  static List<DateTime> getDatePeriod(String period) {
    DateTime now = DateTime.now();
    DateTime start;
    switch (period) {
      case 'Month':
        start = DateTime(now.year, now.month);
        break;
      case 'Week':
        start = DateTime(now.year, now.month, getClosestMonday(now.day));
        break;
      case 'Two weeks':
        start = DateTime(now.year, now.month, getClosestMonday(now.day));
        break;
      case 'Six months':
        //TODO replace with dateUtils addMonths
        start = DateTime(now.year, now.month - 6 <= 0 ? 1 : now.month - 6);
        break;
      case 'Year':
        start = DateTime(now.year);
        break;
      default:
        start = now;
    }

    return [start, now];
  }

  //TODO test
  //TODO add two weeks impl
  static int getClosestMonday(int currentDay) {
    DateTime now = DateTime.now();
    DateTime weekStart = DateTime(now.year, now.month, currentDay);

    while (weekStart.weekday != 1) {
      weekStart = DateTime(weekStart.year, weekStart.month, weekStart.day - 1);
    }

    return weekStart.day;
  }
}
