import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          LocaleKeys.title,
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
              Text('Birthday: 24/02/1994'),
              SizedBox(height: 20,),
              Text('Address information',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 6,),
              Text('State:'),
              Text('City:'),
              Text('Street:'),
              SizedBox(height: 20,),
              Text('Payment information',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 6,),
              Text('Card number:'),
              Text('Expiration date:'),
            ],
          ),
        )
    );
  }
}
