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
      this.priceRangeValues = const RangeValues(10, 1000),
      Map<String, bool> categoriesBool}) {
    this.categoriesBool = categoriesBool ??
        {
          "Furniture": false,
          "Design": false,
          "Electronic": false,
          "Handmade": false,
          "Rustic": false,
          "Practical": false,
          "Unbranded": false,
          "Ergonomic": false,
          "Mechanical": false,
          "Wood": false,
          "Iron": false,
          "Plastic": false,
        };
  }
}
