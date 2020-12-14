import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  CustomAppBar(this.title) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title.tr()),
        leading: Builder(
          builder: (context) {
            print("Current route:" + ModalRoute.of(context).settings.name);
            return (ModalRoute.of(context).settings.name == Navigator.defaultRouteName) ?
            IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer())
            : IconButton(icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context));
          },
        )
    );
  }
}