import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';

class SearchFilters {
  String queryText;
  String dropdownValue;
  bool showFilters;
  bool showAROnly;
  RangeValues priceRangeValues;
  Map<String, bool> categoriesBool;

  SearchFilters({
    this.queryText = "",
    this.dropdownValue = LocaleKeys.filter_cheapest_first,
    this.showFilters = false,
    this.showAROnly = false,
    this.priceRangeValues = const RangeValues(10, 500),
    this.categoriesBool = const {
      "Cat1": false,
      "Cat2": false,
      "Cat3": false,
      "Cat4": false,
      "Cat5": false
    },
  });
}