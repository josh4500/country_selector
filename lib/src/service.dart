import 'data/country.dart';
import 'models/country.dart';

class CountryselectorHelper {
  static Country? getCountry({
    String? code2,
    String? code3,
    String? dialingCode,
    String? countryName,
  }) {
    Country? country;
    if (countryName != null) {
      country = _parseCountryName([countryName]).first;
    }
    return country;
  }

  static List<Country> getCountries({
    List<String>? code2,
    List<String>? code3,
    List<String>? dialingCode,
    List<String>? countryName,
  }) {
    return [];
  }
}

class CountrySelectorFilter {
  final Iterable<Country> _countryList;
  List<Country> get countrylist => _countryList.toList();
  CountrySelectorFilter._internal(this._countryList);

  factory CountrySelectorFilter.code2(List<String> code2) {
    return CountrySelectorFilter._internal(_parseCode2(code2));
  }

  factory CountrySelectorFilter.code3(List<String> code3) {
    final countryList = countries.where((e) =>
        code3.contains(e.code3.toLowerCase()) || code3.contains(e.code3));
    return CountrySelectorFilter._internal(countryList);
  }

  factory CountrySelectorFilter.countryName(List<String> name) {
    final countryList = countries.where(
        (e) => name.contains(e.name.toLowerCase()) || name.contains(e.name));
    return CountrySelectorFilter._internal(countryList);
  }

  factory CountrySelectorFilter.dialingCode(List<String> dialingCode) {
    final countryList =
        countries.where((e) => dialingCode.contains(e.dialingCode));
    return CountrySelectorFilter._internal(countryList);
  }
}

Iterable<Country> _parseCode2(List<String> code2) {
  return countries.where(
      (e) => code2.contains(e.code2.toLowerCase()) || code2.contains(e.code2));
}

Iterable<Country> _parseCountryName(List<String> name) {
  return countries.where(
      (e) => name.contains(e.name.toLowerCase()) || name.contains(e.name));
}

class CountrySelectorDecoration {}
