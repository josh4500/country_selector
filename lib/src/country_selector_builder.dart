import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../country_selector.dart';
import 'data/country.dart';
import 'models/country.dart';
import 'models/state.dart';
import 'utils/enums.dart';
import 'widgets/no_selected_country.dart';
import 'widgets/selected_country_state.dart';

class CountrySelectorBuilder extends StatefulWidget {
  const CountrySelectorBuilder({
    super.key,
    this.controller,
    this.enabled = true,
    this.filters = const [],
    this.showStates = false,
    this.showSearchBar = true,
    this.selectorType = CountrySelectorType.country,
    this.selectorStyle = CountrySelectorStyle.menu,
    this.menuOffset,
    this.menuShape,
    this.menuExpand,
    this.searchBarHintText,
    this.searchBarInputDecoration,
    this.decoration,
    this.defaultCountry,
    this.defaultState,
    this.countryItemBuilder,
    this.selectedCountryBuilder,
    this.selectedStatesBuilder,
    this.statesItemBuilder,
    this.onCountryChange,
    this.onStatesChange,
  });

  final CountrySelectorController? controller;

  final bool enabled;
  final bool showStates;

  final List<CountrySelectorFilter> filters;

  final CountrySelectorStyle selectorStyle;
  final CountrySelectorType selectorType;
  final Offset? menuOffset;
  final ShapeBorder? menuShape;
  final bool? menuExpand;

  final bool showSearchBar;
  final String? searchBarHintText;
  final InputDecoration? searchBarInputDecoration;

  final String? defaultCountry;
  final String? defaultState;

  final BoxDecoration? decoration;

  final Widget Function(
    BuildContext context,
    Widget flag,
    Country country,
    CountrySelectionState state,
  )? selectedCountryBuilder;

  final Widget Function(
    BuildContext context,
    States? country,
    CountrySelectionState state,
  )? selectedStatesBuilder;

  final Widget Function(BuildContext context, Country country)?
      countryItemBuilder;
  final Widget Function(BuildContext context, States country)?
      statesItemBuilder;

  final ValueChanged<Country?>? onCountryChange;
  final ValueChanged<Country?>? onStatesChange;

  @override
  State<CountrySelectorBuilder> createState() => CountrySelectorBuilderState();
}

class CountrySelectorBuilderState extends State<CountrySelectorBuilder> {
  late final CountrySelectorController _effectiveController =
      widget.controller ?? CountrySelectorController();

  final _popMenuStateKey = GlobalKey<PopupMenuButtonState>();
  bool get _menuEnabled => widget.selectorStyle == CountrySelectorStyle.menu;

  List<Country> countryList = [];

  @override
  void initState() {
    super.initState();
    _effectiveController.sync = this;
    if (_effectiveController.autoValidate) _effectiveController.autoValidates();
    if (widget.filters.isNotEmpty) {
      for (var element in widget.filters) {
        countryList.addAll(element.countrylist);
      }
    } else {
      countryList = countries;
    }
  }

  @override
  void dispose() {
    // _effectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _effectiveController,
      builder: (context, child) {
        return Consumer<CountrySelectorController>(
            builder: (context, state, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: widget.decoration,
                child: GestureDetector(
                  onTap: openCountrySelector,
                  child: PopupMenuButton<Country>(
                    key: _popMenuStateKey,
                    enabled: _menuEnabled,
                    enableFeedback: true,
                    tooltip: 'Select country',
                    onSelected: widget.onCountryChange,
                    padding: EdgeInsets.zero,
                    elevation: 2.0,
                    position: widget.menuOffset != null
                        ? PopupMenuPosition.over
                        : PopupMenuPosition.under,
                    splashRadius: 15,
                    itemBuilder: (ctx) {
                      if (widget.selectorType == CountrySelectorType.country) {
                        return List.generate(
                          countryList.length,
                          (index) {
                            final country = countryList[index];
                            final flag =
                                'assets/flags/${country.code2.toLowerCase()}.svg';
                            return PopupMenuItem(
                              height: 8,
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisSize: widget.menuExpand ?? false
                                      ? MainAxisSize.min
                                      : MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: SizedBox(
                                        width: 20,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          flag,
                                          fit: BoxFit.fitWidth,
                                          package: 'flutter_country',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        country.name,
                                        style: const TextStyle(
                                          color: Color(0xFF3353B6),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                              onTap: () {
                                _effectiveController.selectedCountry = country;
                                if (widget.onCountryChange != null) {
                                  widget.onCountryChange!(country);
                                }
                              },
                            );
                          },
                        );
                      } else {
                        if (state.selectionState ==
                            CountrySelectionState.NotSelected) {
                          return [];
                        }
                        final states = state.selectedCountry.states;
                        return List.generate(
                          states.length,
                          (index) {
                            final state = states[index];
                            return PopupMenuItem(
                              height: 8,
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(state.name)),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                              onTap: () =>
                                  _effectiveController.selectedStates = state,
                            );
                          },
                        );
                      }
                    },
                    shape: widget.menuShape ??
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                    offset: widget.menuOffset ?? Offset.zero,
                    child: Builder(
                      builder: (context) {
                        if (widget.selectedCountryBuilder != null &&
                            widget.selectorType ==
                                CountrySelectorType.country) {
                          return widget.selectedCountryBuilder!(
                            context,
                            SizedBox(
                              width: 20,
                              height: 18,
                              child: SvgPicture.asset(
                                'assets/flags/${state.selectedCountry.code2.toLowerCase()}.svg',
                                fit: BoxFit.fitWidth,
                                package: 'flutter_country',
                              ),
                            ),
                            state.selectedCountry,
                            state.selectionState,
                          );
                        }
                        if (widget.selectedStatesBuilder != null &&
                            widget.selectorType == CountrySelectorType.state) {
                          return widget.selectedStatesBuilder!(
                            context,
                            state.selectedStates,
                            state.selectionState,
                          );
                        }
                        if (state.selectionState ==
                            CountrySelectionState.NotSelected) {
                          return const NoSelectedCountryWidget();
                        }
                        return const SelectedCountryStateWidget();
                      },
                    ),
                  ),
                ),
              ),
              if (state.error != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${state.error}',
                  style: const TextStyle(
                    color: Color(0xFFFF5E5E),
                    fontSize: 12,
                  ),
                ),
              ]
            ],
          );
        });
      },
    );
  }

  Future<void> openCountrySelector() async {
    if (_menuEnabled) {
      _popMenuStateKey.currentState!.showButtonMenu();
    } else {
      _showSheets();
    }
  }

  _showSheets() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      builder: (ctx) {
        return ChangeNotifierProvider.value(
          value: _effectiveController,
          builder: (context, child) {
            return Consumer<CountrySelectorController>(
                builder: (context, state, _) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.flag),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('+234'),
                            ),
                            const Expanded(child: Text('Nigeria')),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
          },
        );
      },
    );
  }
}
