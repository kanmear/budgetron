import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/db/groups_controller.dart';
import 'package:budgetron/models/category/group.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/logic/category/category_service.dart';
import 'package:budgetron/ui/classes/floating_action_button.dart';
import 'package:budgetron/routes/popups/group/new_group_popup.dart';
import 'package:budgetron/routes/pages/group/group_overview_page.dart';

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
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  itemBuilder: (BuildContext context, int index) {
                    return GroupListTile(group: groups[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 8);
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
}

class GroupListTile extends StatelessWidget {
  const GroupListTile({super.key, required this.group});

  final CategoryGroup group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _goToGroupOverview(context),
      child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.name, style: BudgetronFonts.nunitoSize16Weight400),
              const SizedBox(height: 8),
              GroupCategoriesList(categories: group.categories.toList())
            ],
          )),
    );
  }

  void _goToGroupOverview(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GroupOverviewPage(groupId: group.id)));
}

class GroupCategoriesList extends StatelessWidget {
  const GroupCategoriesList({super.key, required this.categories});

  final List<EntryCategory> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        //APPROACH is there a better way to handle 'RenderBox was not laid out'?
        //HACK height value is take from design
        height: 40,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GroupCategoryTile(category: categories[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 8);
            },
            itemCount: categories.length));
  }
}

class GroupCategoryTile extends StatelessWidget {
  const GroupCategoryTile(
      {super.key,
      required this.category,
      this.isRemovable = false,
      this.onCloseTap});

  final EntryCategory category;
  final Function? onCloseTap;
  final bool isRemovable;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(Icons.square_rounded,
                  size: 18,
                  color: CategoryService.stringToColor(category.color))),
          Text(category.name, style: BudgetronFonts.nunitoSize16Weight400),
          _resolveTrailing(context)
        ]));
  }

  Widget _resolveTrailing(BuildContext context) {
    if (isRemovable) {
      return Row(children: [
        const SizedBox(width: 16),
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onCloseTap!(category),
            child: Icon(Icons.close,
                size: 18, color: Theme.of(context).colorScheme.primary))
      ]);
    }
    return const SizedBox();
  }
}
