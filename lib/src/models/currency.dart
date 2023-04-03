class Currency {
  final String name;
  final String sign;
  final String symbol;
  final String? code;

  static Currency get notSelected => Currency(name: '', sign: '', symbol: '');

  Currency({
    required this.name,
    required this.sign,
    required this.symbol,
    this.code,
  });
}
