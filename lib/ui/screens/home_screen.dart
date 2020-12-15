import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(LocaleKeys.title),
        drawer: SideMenu(),
        body: Column(
          children: [
            Text('Hot Deals'),
            Text('Popular')
          ],
        )
    );
  }
}
