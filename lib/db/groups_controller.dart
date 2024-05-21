import 'package:budgetron/models/category/group.dart';

import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/objectbox.g.dart';

class GroupsController {
  static Stream<List<CategoryGroup>> getGroups() {
    return _getCategoryBox()
        .query()
        .order(CategoryGroup_.id, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static Box<CategoryGroup> _getCategoryBox() =>
      ObjectBox.store.box<CategoryGroup>();
}
