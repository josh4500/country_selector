import 'package:flutter/material.dart';

import '../models/country.dart';
import '../models/state.dart';

class SelectedCountryStateWidget extends StatefulWidget {
  final Country? country;
  final States? state;
  const SelectedCountryStateWidget({super.key, this.country, this.state})
      : assert(country == null && state == null,
            'Country and State cannot be null');

  @override
  State<SelectedCountryStateWidget> createState() =>
      _SelectedCountryStateWidgetState();
}

class _SelectedCountryStateWidgetState
    extends State<SelectedCountryStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            (widget.country?.name ?? widget.state?.name)!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF3353B6),
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 16),
        const RotatedBox(
          quarterTurns: 1,
          child: Icon(
            Icons.chevron_right_rounded,
            size: 22,
            color: Color(0xFF3353B6),
          ),
        ),
        const SizedBox(width: 16),
        const Divider(height: 1.5, color: Color(0xFF3353B6))
      ],
    );
  }
}
