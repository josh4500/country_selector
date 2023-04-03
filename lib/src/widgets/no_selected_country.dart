import 'package:flutter/material.dart';

import '../models/country.dart';
import 'selected_country_state.dart';

class NoSelectedCountryWidget extends StatelessWidget {
  const NoSelectedCountryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectedCountryStateWidget(country: Country.notSelected());
  }
}
