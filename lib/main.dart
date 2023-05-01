import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(tabs: [
                  Tab(icon: Icon(Icons.add)),
                  Tab(icon: Icon(Icons.bar_chart))
                ]),
                title: const Text('Tabs'),
              ),
              body: const TabBarView(children: [EntriesPage(), Text('Stats')]),
            ),
          ),
        ));
  }
}

class AppState extends ChangeNotifier {
  var entries = <String>[];

  void addEntry(String entry) {
    entries.add(entry);
    notifyListeners();
  }

  void clearEntries() {
    entries.clear();
    notifyListeners();
  }
}

class EntriesPage extends StatelessWidget {
  const EntriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var entries = appState.entries;

    return Scaffold(
        body: ListView(
          children: [
            for (var entry in entries)
              ListTile(
                leading: const Icon(Icons.money),
                title: Text(entry),
              )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const EntryDialog()),
          child: const Icon(Icons.add),
        ));
  }
}

class EntryDialog extends StatefulWidget {
  const EntryDialog({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return AlertDialog(
      title: const Text("Entry"),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: 'Enter value'),
      ),
      actions: [
        TextButton(
            onPressed: () =>
                {appState.addEntry(controller.text), print(controller.text)},
            child: const Text("Add entry")),
        TextButton(
            onPressed: () => appState.clearEntries(),
            child: const Text("Clear all entries"))
      ],
    );
  }
}
