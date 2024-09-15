enum BudgetronPage {
  entries(pageIndex: 0),
  stats(pageIndex: 1),
  groups(pageIndex: 2),
  accounts(pageIndex: 3);

  final int pageIndex;

  const BudgetronPage({required this.pageIndex});
}
