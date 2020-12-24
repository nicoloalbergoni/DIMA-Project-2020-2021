import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/firebase_query_future_builder.dart';
import 'package:realiteye/ui/widgets/order_card.dart';
import 'package:realiteye/utils/data_service.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userUid = StoreProvider.of<AppState>(context).state.firebaseUser.uid;

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
              FirebaseQueryFutureBuilder(getUserInProgressOrders(userUid),
                  (docId, data) {
                    return OrderCard(docId, data['issue_date'],
                      data['delivery_date'], double.parse(data['total_cost']));
                  }),
              FirebaseQueryFutureBuilder(getUserCompletedOrders(userUid),
                      (docId, data) {
                    return OrderCard(docId, data['issue_date'],
                        data['delivery_date'], double.parse(data['total_cost']));
                  }),
            ],
          ),
        )
    );
  }
}
