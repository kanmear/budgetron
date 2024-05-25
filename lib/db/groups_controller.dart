import 'package:budgetron/models/category/group.dart';

import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/objectbox.g.dart';

class GroupsController {
  static Stream<List<CategoryGroup>> getGroups() {
    return _getGroupBox()
        .query()
        .order(CategoryGroup_.id, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static int addGroup(CategoryGroup group) => _getGroupBox().put(group);

  static Box<CategoryGroup> _getGroupBox() =>
      ObjectBox.store.box<CategoryGroup>();
}