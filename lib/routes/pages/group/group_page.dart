import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/db/groups_controller.dart';
import 'package:budgetron/models/category/group.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/popups/group/new_group_popup.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BudgetronAppBar(
            leading: ArrowBackIconButton(), title: 'Groups'),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: const Column(children: [SizedBox(height: 8), GroupsList()]),
        floatingActionButton: BudgetronFloatingActionButton(
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => NewGroupDialog())));
  }
}

class GroupsList extends StatelessWidget {
  const GroupsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<CategoryGroup>>(
          stream: GroupsController.getGroups(),
          builder: (context, snapshot) {
            if (snapshot.data?.isNotEmpty ?? false) {
              List<CategoryGroup> groups = snapshot.data!;
              groups.sort((a, b) => a.name.compareTo(b.name));

              return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return GroupListTile(group: groups[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(width: 8);
                  },
                  itemCount: groups.length);
            } else {
              return Center(
                child: Text('No groups in database',
                    style: BudgetronFonts.nunitoSize16Weight300Gray),
              );
            }
          }),
    );
  }

  void _goToGroupOverview(CategoryGroup group, BuildContext context) {}
}

class GroupListTile extends StatelessWidget {
  const GroupListTile({super.key, required this.group});

  final CategoryGroup group;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
