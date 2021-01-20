import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/ui/widgets/firebase_query_future_builder.dart';
import 'package:realiteye/ui/widgets/order_card.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/utils.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String uid = getUID(context);
    if (uid == null)
      return Container();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.orders_title.tr()),
            bottom: TabBar(
              tabs: [
                Tab(text: LocaleKeys.orders_tab_progress.tr(),),
                Tab(text: LocaleKeys.orders_tab_completed.tr(),),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FirebaseQueryFutureBuilder(getUserInProgressOrders(uid),
                  (docId, data) {
                    return OrderCard(docId.id, data['issue_date'],
                      data['delivery_date'], data['total_cost']);
                  }),
              FirebaseQueryFutureBuilder(getUserCompletedOrders(uid),
                      (docId, data) {
                    return OrderCard(docId.id, data['issue_date'],
                        data['delivery_date'], data['total_cost']);
                  }),
            ],
          ),
        )
    );
  }
}
