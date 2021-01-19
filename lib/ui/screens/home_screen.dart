import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeProductShowcase(LocaleKeys.home_deals.tr(), getHotDeals()),
          HomeProductShowcase(LocaleKeys.home_popular.tr(), getPopulars()),
        ],
      )
    );
  }
}
