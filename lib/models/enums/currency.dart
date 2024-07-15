//REFACTOR this should be in a JSON/ARB

enum Currency {
  usd(name: 'United States dollar', code: 'USD', symbol: '\$'),
  hryvnia(name: 'Ukrainian hryvnia', code: 'UAH', symbol: '₴'),
  belruble(name: 'Belarusian Ruble', code: 'BYN', symbol: 'Rbl');

  final String name;
  final String code;
  final String symbol;

  const Currency({
    required this.name,
    required this.code,
    required this.symbol,
  });
}
