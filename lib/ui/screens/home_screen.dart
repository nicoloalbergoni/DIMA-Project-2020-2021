
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/search_filters.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/home_filter_card.dart';
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
        padding: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(flex: 1,),
            HomeProductShowcase(LocaleKeys.home_deals.tr(), getHotDeals()),
            Spacer(flex: 1,),
            HomeProductShowcase(LocaleKeys.home_popular.tr(), getPopulars()),
            Spacer(flex: 1,),
            Expanded(
              flex: 8,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 52,
                    child: HomeFilterCard(
                      'assets/images/home_card_1.jpg',
                      LocaleKeys.home_card_1.tr(),
                      //width: 210,
                      //height: 120,
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
                                }));
                      }
                    ),
                  ),
                  Spacer(flex: 2,),
                  Expanded(
                    flex: 40,
                    child: HomeFilterCard(
                      'assets/images/home_card_4.jpg',
                      LocaleKeys.home_card_2.tr(),
                      //width: 170,
                      //height: 120,
                      blurX: 0.2,
                      blurY: 0.2,
                      onTap: () {
                        Navigator.pushNamed(context, '/search',
                            arguments: SearchFilters(
                              queryText: "awesome",
                              showFilters: true,
                              priceRangeValues: RangeValues(0, 200),
                            )
                        );
                      },
                    ),
                  )
                ],
              )
            )
          ],
        ),
      )
    );
  }
}
