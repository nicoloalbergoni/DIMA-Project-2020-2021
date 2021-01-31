import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/search_filters.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/home_product_showcase.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/data_service.dart';

class HomeScreen extends StatelessWidget {
  static var scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        'Realiteye',
        showCartIcon: true,
        showSearchIcon: true,
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: EdgeInsets.only(top: 14.0, bottom: 4.0, left: 4.0, right: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeProductShowcase(LocaleKeys.home_deals.tr(), getHotDeals()),
            HomeProductShowcase(LocaleKeys.home_popular.tr(), getPopulars()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 210,
                  height: 100,
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/search',
                            arguments: SearchFilters(
                              showAROnly: true,
                              showFilters: true,
                              categoriesBool: {
                                "Furniture": true,
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
                                "Plastic": false
                            })
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("Have a look at our furniture, directly in your home!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ),
                  ),
                ),
                SizedBox(
                  width: 170,
                  height: 100,
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/search',
                            arguments: SearchFilters(
                              queryText: "awesome",
                              showFilters: true,
                              priceRangeValues: RangeValues(0, 200),
                            )
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("Check our awesome economic products",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, ),
                          ),
                        ),
                      )
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
