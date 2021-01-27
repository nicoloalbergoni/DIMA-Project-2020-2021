import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/search_filters_callbacks.dart';

class FilterBar extends StatelessWidget {

  final String dropdownValue;
  final bool showFilters;
  final bool showAROnly;
  final RangeValues priceRangeValues;
  final Map<String, bool> categoriesBool;
  final SearchFiltersCallbacks callbacks;

  FilterBar(this.dropdownValue, this.showFilters, this.showAROnly,
      this.priceRangeValues, this.categoriesBool, this.callbacks);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     offset: Offset(0.0, 1.0), //(x,y)
          //     blurRadius: 6.0,
          //   ),
          // ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5, left: 0),
                    child: Text(LocaleKeys.filter_order_by.tr()),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down_sharp),
                    iconSize: 24,
                    onChanged: callbacks.onDropdownChangedCallback,
                    items: <String>[
                      LocaleKeys.filter_cheapest_first,
                      LocaleKeys.filter_expensive_first,
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.tr()),
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: callbacks.onFilterButtonPressedCallback,
                    child: Text(
                      LocaleKeys.filter_button_text.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: showFilters,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.remove_red_eye),
                        SizedBox(width: 4,),
                        Text(LocaleKeys.filter_AR_toggle_text.tr()),
                        Switch(
                          value: showAROnly,
                          onChanged: callbacks.onARToggleChangedCallback,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(LocaleKeys.filter_price_range_text.tr()),
                        Expanded(
                          child: RangeSlider(
                            values: priceRangeValues,
                            labels: RangeLabels(
                              priceRangeValues.start.round().toString(),
                              priceRangeValues.end.round().toString(),
                            ),
                            min: 0,
                            max: 1000,
                            divisions: 200,
                            onChanged: callbacks.onPriceSliderChangedCallback,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Text(LocaleKeys.filter_categories_text.tr()),
                          ),
                          Flexible(child: _buildFilterChips()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 2,),
            ],
          ),
        ),
      );
  }

  Widget _buildFilterChips() {
    List<List<String>> categories = [
      [LocaleKeys.categories_furniture, 'Furniture'],
      [LocaleKeys.categories_design, 'Design'],
      [LocaleKeys.categories_electronic, 'Electronic'],
      [LocaleKeys.categories_handmade, 'Handmade'],
      [LocaleKeys.categories_rustic, 'Rustic'],
      [LocaleKeys.categories_practical, 'Practical'],
      [LocaleKeys.categories_unbranded, 'Unbranded'],
      [LocaleKeys.categories_ergonomic, 'Ergonomic'],
      [LocaleKeys.categories_mechanical, 'Mechanical'],
      [LocaleKeys.categories_wood, 'Wood'],
      [LocaleKeys.categories_iron, 'Iron'],
      [LocaleKeys.categories_plastic, 'Plastic'],
    ];

    //TODO: Style Scrollbar
    return Scrollbar(
      thickness: 3,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return FilterChip(
            label: Text(categories[index][0].tr()),
            selected: categoriesBool[categories[index][1]],
            onSelected: (_) => callbacks.onCategoriesSelectedCallback(categories[index][1], context),
          );
        },
        separatorBuilder: (BuildContext context, _) => SizedBox(
          width: 5,
        ),
      ),
    );
  }
}
