import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/utils/utils.dart';
import 'package:realiteye/view_models/side_menu_vm.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: StoreConnector<AppState, SideMenuViewModel>(
            converter: (store) {
      return SideMenuViewModel(
          theme: store.state.theme,
          firebaseUser: store.state.firebaseUser,
          switchThemeCallback: (mode) =>
              store.dispatch(SwitchThemeAction(mode)),
          logoutUser: () =>
              store.dispatch(FirebaseLogoutAction())
      );
    }, builder: (context, viewModel) {
      return Column(children: [
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
              ..._buildMenuItems(viewModel, context),


            ],
          ),
        ),
        Row(
          children: [
            IconButton(
                icon: Image(
                  image: AssetImage("assets/icons/usa.png"),
                  color: null,
                ),
                iconSize: 54,
                onPressed: () {
                  context.locale = Locale('en', 'US');
                }),
            IconButton(
                icon: Image(
                  image: AssetImage("assets/icons/ita.jpg"),
                  color: null,
                ),
                iconSize: 45,
                onPressed: () {
                  context.locale = Locale('it', 'IT');
                }),
            Spacer(flex: 1),
            (viewModel.theme == ThemeMode.light)
                ? IconButton(
                    icon: Icon(Icons.wb_sunny),
                    onPressed: () {
                      viewModel.switchThemeCallback(ThemeMode.dark);
                    },
                    padding: EdgeInsets.only(right: 10),
                  )
                : IconButton(
                    icon: Icon(Icons.wb_sunny_outlined),
                    onPressed: () {
                      viewModel.switchThemeCallback(ThemeMode.light);
                    },
                    padding: EdgeInsets.only(right: 10))
          ],
        ),
      ]);
    }));
  }
}


List<Widget> _buildMenuItems(SideMenuViewModel viewModel, BuildContext context) {
  return (viewModel.firebaseUser != null) ?
  <Widget>[
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
    Divider(thickness: 3, indent: 10, endIndent: 10,),
    ListTile(
      title: Text('Logout'),
      leading: Icon(Icons.logout),
      onTap: () async {
        await _auth.signOut();
        viewModel.logoutUser();
        displaySnackbarWithText(context, 'Logout successfully');

        // Then close the drawer
        Navigator.pop(context);
      },
    ),
  ]
      : <Widget>[
    ListTile(
      title: Text('Login'),
      leading: Icon(Icons.login),
      onTap: () async {
        final message = await Navigator.pushNamed(context, "/login");
        if (message != null) {
          displaySnackbarWithText(context, message);
        }

        // Close the drawer
        Navigator.pop(context);
      },
    ),
  ];
}
