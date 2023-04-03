import 'package:flutter/material.dart';

import '../utils/enums.dart';
import 'currency.dart';
import 'state.dart';

class Country {
  final String name;
  final IconData flag;
  final States capital;
  final Region region;
  final List<States> states;
  final String dialingCode;
  final String code2;
  final String code3;
  final Currency currency;

  Country({
    required this.name,
    this.flag = Icons.flag,
    required this.capital,
    required this.region,
    required this.states,
    required this.dialingCode,
    required this.code2,
    required this.code3,
    required this.currency,
  });

  factory Country.notSelected() {
    return Country(
      name: "Select",
      flag: Icons.abc,
      capital: States.notSelected,
      region: Region.Unknown,
      states: [],
      dialingCode: '',
      currency: Currency.notSelected,
      code3: '',
      code2: '',
    );
  }
}
