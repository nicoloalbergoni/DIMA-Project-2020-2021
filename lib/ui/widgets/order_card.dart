import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${LocaleKeys.orders_id.tr()}: 1234',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text('${LocaleKeys.orders_start.tr()}: 12/04/2020'),
              Text('${LocaleKeys.orders_expected.tr()}:'),
              SizedBox(height: 6,),
              Align(
                alignment: Alignment.bottomRight,
                child: Text('${LocaleKeys.orders_total.tr()}: 19.99\$'),
              )
            ],
          ),
        )
    );
  }
}
