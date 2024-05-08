import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/enums/date_period.dart';
import 'package:budgetron/logic/budget/budget_service.dart';

class EntryService {
  static int createEntry(Entry entry, EntryCategory category) {
    category.usages++;
    CategoryController.updateCategory(category);

    entry.category.target = category;
    if (category.isExpense) entry.value *= -1.0;
    return EntryController.addEntry(entry);
  }

  static void updateEntry(Entry entry, double newValue) {
    EntryCategory category = entry.category.target!;
    if (category.isBudgetTracked) {
      double delta = -(newValue - entry.value);
      BudgetService.updateBudget(category.id, delta);
    }

    entry.value = category.isExpense ? -newValue : newValue;
    EntryController.addEntry(entry);
  }

  static deleteEntry(Entry entry) {
    EntryCategory category = entry.category.target!;
    if (category.isBudgetTracked) {
      BudgetService.deleteEntryFromBudget(category.id, entry.id, entry.value);
    }

    EntryController.deleteEntry(entry.id);
  }

  static double calculateTotalValue(List<Entry> entries) {
    if (entries.isEmpty) return 0;

    return entries
        .map((entry) => entry.value)
        .reduce((value, element) => value + element)
        .abs();
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
