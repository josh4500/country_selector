import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../country_selector.dart';

class CountrySelectorView extends StatefulWidget {
  const CountrySelectorView({
    super.key,
    this.code2,
    this.code3,
    this.dialingCode,
    this.countryName,
    this.controller,
  });

  final CountrySelectorController? controller;
  final String? code2;
  final String? code3;
  final String? dialingCode;
  final String? countryName;

  @override
  State<CountrySelectorView> createState() => _CountrySelectorViewState();
}

class _CountrySelectorViewState extends State<CountrySelectorView> {
  Country? _country;
  late final CountrySelectorController _effectiveController =
      widget.controller ?? CountrySelectorController();

  @override
  void initState() {
    super.initState();

    _country = CountryselectorHelper.getCountry(
      code2: widget.code2,
      code3: widget.code3,
      dialingCode: widget.dialingCode,
      countryName: widget.countryName,
    );
    _effectiveController.selectedCountry = _country;
  }

  @override
  void dispose() {
    _effectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_country == null) {
        return const SizedBox();
      }
      final country = _country!;
      final flag = 'assets/flags/${country.code2.toLowerCase()}.svg';
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 18,
            child: SvgPicture.asset(
              flag,
              fit: BoxFit.fitWidth,
              package: 'flutter_country',
            ),
          ),
          // const SizedBox(width: 4),
          // Text(country.name),
          const SizedBox(width: 4),
          Text(country.dialingCode),
          const SizedBox(width: 2),
        ],
      );
    });
  }
}
