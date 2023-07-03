import 'package:budgetron/models/entry.dart';

class EntryService {
  static void formEntriesData(List<Entry> data,
      Map<DateTime, List<Entry>> entriesMap, List<DateTime> entryDates) {
    for (var element in data) {
      _addEntryToMap(entriesMap, element);
    }

    entryDates.addAll(entriesMap.keys.toList());
    //TODO is it an optimal approach?
  }

  static void _addEntryToMap(
      Map<DateTime, List<Entry>> entriesMap, Entry entry) {
    DateTime dateTime =
        DateTime(entry.dateTime.year, entry.dateTime.month, entry.dateTime.day);
    if (entriesMap.containsKey(dateTime)) {
      entriesMap.update(dateTime, (value) => List.from(value)..addAll({entry}));
    } else {
      entriesMap[dateTime] = List.from({entry});
    }
  }
}
