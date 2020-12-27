import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/home_product_showcase.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var testList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    return Scaffold(
        appBar: CustomAppBar(
          'Realiteye',
          showCartIcon: true,
          showSearchIcon: true,
        ),
        drawer: SideMenu(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 5,
              child: HomeProductShowcase(LocaleKeys.home_deals.tr(), testList),
            ),
            Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 5,
              child: HomeProductShowcase(LocaleKeys.home_popular.tr(), testList),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ));
  }
}