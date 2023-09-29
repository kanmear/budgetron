import 'package:flutter/cupertino.dart';

import 'package:budgetron/ui/data/colors.dart';

class HorizontalSeparator extends StatelessWidget {
  const HorizontalSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
          border: Border.all(color: BudgetronColors.gray0, width: 1)),
    );
  }
}
