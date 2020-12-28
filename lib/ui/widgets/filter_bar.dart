import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String dropdownValue = 'Newest First';
  bool showFilters;
  bool showAROnly;
  RangeValues priceRangeValues = const RangeValues(10, 500);

  Map<String, bool> categoriesBool = {
    "Cat1": false,
    "Cat2": false,
    "Cat3": false,
    "Cat4": false,
    "Cat5": false
  };

  @override
  void initState() {
    super.initState();
    showFilters = false;
    showAROnly = false;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
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
                    child: Text("Order by: "),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down_sharp),
                    iconSize: 24,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>[
                      'Newest First',
                      'Cheapest First',
                      'Expensive First'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        showFilters = !showFilters;
                      });
                    },
                    child: Text(
                      "FILTER",
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
                        Text(" AR Available"),
                        Switch(
                            value: showAROnly,
                            onChanged: (value) {
                              setState(() {
                                showAROnly = value;
                              });
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Price range: "),
                        Expanded(
                          child: RangeSlider(
                            values: priceRangeValues,
                            labels: RangeLabels(
                              priceRangeValues.start.round().toString(),
                              priceRangeValues.end.round().toString(),
                            ),
                            min: 0,
                            max: 500,
                            divisions: 500,
                            onChanged: (values) {
                              setState(() {
                                priceRangeValues = values;
                              });
                            },
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
                            child: Text("Categories: "),
                          ),
                          Flexible(child: _buildFilterChips()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    List categories = ["Cat1", "Cat2", "Cat3", "Cat4", "Cat5"];

    //TODO: Style Scrollbar
    return Scrollbar(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return FilterChip(
            label: Text(categories[index]),
            selected: categoriesBool[categories[index]],
            onSelected: (_) {
              setState(() {
                categoriesBool[categories[index]] =
                    !categoriesBool[categories[index]];
              });
            },
          );
        },
        separatorBuilder: (BuildContext context, _) => SizedBox(
          width: 5,
        ),
      ),
    );
  }
}
