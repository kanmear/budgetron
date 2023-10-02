import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/enums/date_period.dart';

class EntryService {
  static void createEntry(Entry entry, EntryCategory category) {
    entry.value *= (category.isExpense ? -1 : 1);
    category.usages++;
    CategoryController.updateCategory(category);

    entry.category.target = category;
    EntryController.addEntry(entry);
  }

  static double calculateTotalValue(List<Entry> entries) {
    if (entries.isNotEmpty) {
      return entries
          .map((entry) => entry.value)
          .reduce((value, element) => value + element)
          .abs();
    }

    return 0;
  }

  static void formEntriesData(
      DatePeriod datePeriod,
      List<Entry> entries,
      Map<DateTime, Map<EntryCategory, List<Entry>>> entriesMap,
      List<DateTime> entryDates) {
    for (var entry in entries) {
      _addEntryToMap(entriesMap, entry, datePeriod);
    }

    entryDates.addAll(entriesMap.keys.toList());
    //APPROACH is this approach optimal?
  }

  static void _addEntryToMap(
      Map<DateTime, Map<EntryCategory, List<Entry>>> entriesMap,
      Entry entry,
      DatePeriod datePeriod) {
    DateTime dateTime = datePeriod == DatePeriod.day
        ? DateTime(
            entry.dateTime.year, entry.dateTime.month, entry.dateTime.day)
        : DateTime(entry.dateTime.year, entry.dateTime.month);
    EntryCategory category = entry.category.target!;

    if (entriesMap.containsKey(dateTime)) {
      Map<EntryCategory, List<Entry>> currentEntries = entriesMap[dateTime]!;

      // if an entry with the same category exists - update that entry
      if (currentEntries.containsKey(category)) {
        List<Entry> sameCategoryEntries = currentEntries[category]!;
        sameCategoryEntries.addAll(List.from({entry}));

        currentEntries.update(category, (value) => sameCategoryEntries);
      }

      // if category is unique for that date - add as a separate row
      else {
        var categoryMap = entriesMap[dateTime]!;
        categoryMap.addAll({
          category: List.from({entry})
        });

        entriesMap.update(dateTime, (value) => categoryMap);
      }
    } else {
      entriesMap[dateTime] = {
        category: List.from({entry})
      };
    }
  }
}
