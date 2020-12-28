import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/utils/utils.dart';

class OrderCard extends StatelessWidget {
  final String id;
  final Timestamp issueTimestamp;
  final Timestamp deliveryTimestamp;
  final double totalCost;

  OrderCard(this.id, this.issueTimestamp, this.deliveryTimestamp, this.totalCost);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${LocaleKeys.orders_id.tr()}: $id',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text('${LocaleKeys.orders_start.tr()}: ${formatDate(issueTimestamp)}'),
              Text('${LocaleKeys.orders_expected.tr()}: ${formatDate(deliveryTimestamp)}'),
              SizedBox(height: 6,),
              Align(
                alignment: Alignment.bottomRight,
                child: Text('${LocaleKeys.orders_total.tr()}: $totalCost\$'),
              )
            ],
          ),
        )
    );
  }
}
