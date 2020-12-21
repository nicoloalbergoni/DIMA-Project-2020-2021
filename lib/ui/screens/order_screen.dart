import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/ui/widgets/order_card.dart';

class OrderScreen extends StatelessWidget {
  final List _testList = [1,2,3,4,5,6,7,8];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Orders'),
            bottom: TabBar(
              tabs: [
                Tab(text: LocaleKeys.orders_tab_progress.tr(),),
                Tab(text: LocaleKeys.orders_tab_completed.tr(),),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _testList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderCard();
                    }
              ),
              ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _testList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderCard();
                    }
              ),
            ],
          ),
        )
    );
  }
}
