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
      List<Entry> currentEntries = entriesMap[dateTime]!;

      // if an entry with the same category exists - update that entry
      int sameCategoryEntry = currentEntries.indexWhere((element) =>
          element.category.target!.name == entry.category.target!.name);
      if (sameCategoryEntry != -1) {
        Entry updatedEntry = currentEntries[sameCategoryEntry];
        updatedEntry.value += entry.value;
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
}
