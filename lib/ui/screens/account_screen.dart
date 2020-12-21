import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          LocaleKeys.account_title.tr(),
          showCartIcon: true,
        ),
        drawer: SideMenu(),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 160,
                    width: 160,
                    color: Colors.green,
                  ),
                  Text('John Cena',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Text('Email: asd@gmail.com'),
              Text('${LocaleKeys.account_birthday.tr()}: 24/02/1994'),
              SizedBox(height: 20,),
              Text(LocaleKeys.account_address_title.tr(),
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 6,),
              Text('${LocaleKeys.account_address_state.tr()}: '),
              Text('${LocaleKeys.account_address_city.tr()}: '),
              Text('${LocaleKeys.account_address_street.tr()}: '),
              SizedBox(height: 20,),
              Text(LocaleKeys.account_payment_title.tr(),
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 6,),
              Text('${LocaleKeys.account_payment_card.tr()}: '),
              Text('${LocaleKeys.account_payment_expiration.tr()}: '),
            ],
          ),
        )
    );
  }
}
