import 'package:flutter/material.dart';

import '../country_selector.dart';
import 'models/country.dart';
import 'models/state.dart';
import 'utils/enums.dart';

typedef CountryValidationCallback = String? Function(Country? c);
typedef StatesValidationCallback = String? Function(States? s);

class CountrySelectorController extends ChangeNotifier {
  Country? _selectedCountry;
  States? _selectedStates;
  final CountrySelectorType _selectionType;
  final CountryValidationCallback? _validateCountry;
  final StatesValidationCallback? _validateStates;
  final bool _showError;
  final bool _autoValidate;
  final CountrySelectorValidateMode _validateMode;

  CountrySelectorController({
    Country? country,
    States? state,
    CountrySelectorType selectionType = CountrySelectorType.country,
    CountryValidationCallback? validateCountry,
    StatesValidationCallback? validateStates,
    bool showError = true,
    bool autoValidate = true,
    CountrySelectorValidateMode validateMode =
        CountrySelectorValidateMode.onChanged,
  })  : _showError = showError,
        _autoValidate = autoValidate,
        _validateMode = validateMode,
        _selectedStates = state,
        _selectedCountry = country,
        _selectionType = selectionType,
        _validateStates = validateStates,
        _validateCountry = validateCountry;

  CountrySelectionState get selectionState => _selectedCountry == null
      ? CountrySelectionState.NotSelected
      : CountrySelectionState.Selected;

  CountrySelectorBuilderState? _syncState;

  String? _errorMessage;
  String? get error => _errorMessage;
  bool get hasError => _errorMessage != null;

  bool get autoValidate => _autoValidate;
  bool get hasClient => _syncState != null;

  Country get selectedCountry => _selectedCountry ?? Country.notSelected();
  States? get selectedStates => _selectedStates;

  set sync(CountrySelectorBuilderState sync) {
    _syncState = sync;
  }

  void _notify() {
    if (_validateMode == CountrySelectorValidateMode.autoValidate) {
      validate();
      return;
    }
    notifyListeners();
  }

  set selectedStates(States? state) {
    if (_selectedStates == state) {
      return;
    }
    _selectedStates = state;
    _notify();
  }

  set selectedCountry(Country? country) {
    if (_selectedCountry == country) {
      return;
    }
    _selectedCountry = country;
    _notify();
  }

  Future<void> openCountrySelector() async {
    if (_syncState != null) {
      await _syncState!.openCountrySelector();
    }
  }

  bool autoValidates() {
    return validate(false);
  }

  bool validate([bool shouldNotify = true]) {
    if (!_showError) return true;
    String? errorMessage;
    if (_selectionType == CountrySelectorType.country) {
      errorMessage = _validateCountry != null
          ? _validateCountry!(_selectedCountry)
          : _selectedCountry == null
              ? '*Required'
              : null;
    } else {
      errorMessage = _validateStates != null
          ? _validateStates!(_selectedStates)
          : _selectedStates == null
              ? '*Required'
              : null;
    }
    if (errorMessage != _errorMessage) {
      _errorMessage = errorMessage;
      if ((_syncState?.mounted ?? false) && shouldNotify) notifyListeners();
    }
    return errorMessage == null;
  }
}
