import 'package:flutter/material.dart';

class SearchFiltersCallbacks {
  Function(String) onDropdownChangedCallback;
  Function() onFilterButtonPressedCallback;
  Function(bool) onARToggleChangedCallback;
  Function(RangeValues) onPriceSliderChangedCallback;
  Function(String) onCategoriesSelectedCallback;

  SearchFiltersCallbacks(
      this.onDropdownChangedCallback,
      this.onFilterButtonPressedCallback,
      this.onARToggleChangedCallback,
      this.onPriceSliderChangedCallback,
      this.onCategoriesSelectedCallback);
}