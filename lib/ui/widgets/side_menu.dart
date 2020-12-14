import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
        children: [
          Expanded(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Drawer Header'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('My account'),
                  leading: Icon(Icons.account_box),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('My orders'),
                  leading: Icon(Icons.monetization_on_rounded),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Shopping cart'),
                  leading: Icon(Icons.shopping_cart),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return Row(
              children: [
                IconButton(icon: Image(
                  image: AssetImage("assets/icons/usa.png"),
                  color: null,
                ),
                    iconSize: 54,
                    onPressed: () {
                      context.locale = Locale('en', 'US');
                    }),
                IconButton(icon: Image(
                  image: AssetImage("assets/icons/ita.jpg"),
                  color: null,
                ),
                    iconSize: 45,
                    onPressed: () {
                      context.locale = Locale('it', 'IT');
                    }),
                Spacer(flex: 1),
                (state.theme == ThemeMode.light) ?
                  IconButton(icon: Icon(Icons.wb_sunny), onPressed: () {
                    StoreProvider.of<AppState>(context)
                        .dispatch(SwitchThemeAction(ThemeMode.dark));
                  },
                    padding: EdgeInsets.only(right: 10),)
                    : IconButton(icon: Icon(Icons.wb_sunny_outlined), onPressed: () {
                  StoreProvider.of<AppState>(context)
                      .dispatch(SwitchThemeAction(ThemeMode.light));
                },
                    padding: EdgeInsets.only(right: 10))
              ],
            );
          }),
        ],
      )
    );
  }
}
