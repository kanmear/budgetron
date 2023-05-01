import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          body: const TabBarView(children: [Text('Entries'), Text('Stats')]),
        ),
      ),
    );
  }
}
