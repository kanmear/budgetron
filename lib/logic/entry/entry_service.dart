import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';

class EntryService {
  static void createEntry(Entry entry, EntryCategory category) {
    entry.value *= (category.isExpense ? -1 : 1);
    category.usages++;
    CategoryController.updateCategory(category);

    entry.category.target = category;
    EntryController.addEntry(entry);
  }

  static void formEntriesData(List<Entry> data,
      Map<DateTime, List<Entry>> entriesMap, List<DateTime> entryDates) {
    for (var element in data) {
      _addEntryToMap(entriesMap, element);
    }

    entryDates.addAll(entriesMap.keys.toList());
    entryDates.sort(((a, b) => b.compareTo(a)));
    //APPROACH is this approach optimal?
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
}
