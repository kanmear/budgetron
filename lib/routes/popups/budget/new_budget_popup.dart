import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/ui/classes/docked_popup.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/budget.dart';
import 'package:flutter/material.dart';

class NewBudgetDialog extends StatefulWidget {
  const NewBudgetDialog({super.key});

  @override
  State<NewBudgetDialog> createState() => _NewBudgetDialogState();
}

class _NewBudgetDialogState extends State<NewBudgetDialog> {
  String? dropdownValue;

  @override
  initState() {
    super.initState();
    //HACK this should be equal to one of the possible values or null
    dropdownValue = null;
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<EntryCategory>> categories =
        CategoryController.getCategories("", null);

    return DockedDialog(
        title: "New Budget",
        body: Column(children: [
          Container(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            height: 38,
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary)),
            child: StreamBuilder<List<EntryCategory>>(
              stream: categories,
              builder: (context, snapshot) {
                if (snapshot.data?.isNotEmpty ?? false) {
                  return DropdownButton(
                    value: dropdownValue,
                    hint: Row(
                      children: const [
                        SizedBox(width: 8),
                        Text("Choose category"),
                      ],
                    ),
                    underline: const SizedBox(),
                    isExpanded: true,
                    items: snapshot.data!.map((EntryCategory category) {
                      return DropdownMenuItem<String>(
                        value: category.name,
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    icon: const SizedBox(
                      height: 31,
                      width: 31,
                      child: Icon(Icons.arrow_drop_down),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  );
                } else {
                  return const Text("No categories in database");
                }
              },
            ),
          )
        ]));
  }
}
