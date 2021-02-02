import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/screens/home_screen.dart';
import 'package:realiteye/ui/widgets/firebase_doc_future_builder.dart';
import 'package:realiteye/utils/data_service.dart';
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
            logoutUser: () async {
              await updateUserCart(store.state.firebaseUser.uid, store.state.cartItems);
              store.dispatch(FirebaseLogoutAction());
            },
          );
        },
        builder: (context, viewModel) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (viewModel.firebaseUser != null)
                                ? FirebaseDocFutureBuilder(
                                    getUserDocument(viewModel.firebaseUser.uid),
                                    (userData) {
                                    return CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          NetworkImage(userData['photoURL']),
                                    );
                                  })
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    // TODO: Make icon have the same size of the circle avatar
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 62,
                                    ),
                                  ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  viewModel.firebaseUser != null
                                      ? viewModel.firebaseUser.email
                                      : LocaleKeys.drawer_avatar_subtitle.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ))
                          ],
                        ),
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
            ],
          );
        },
      ),
    );
  }
}

List<Widget> _buildMenuItems(
    SideMenuViewModel viewModel, BuildContext context) {
  return (viewModel.firebaseUser != null)
      ? <Widget>[
          ListTile(
            title: Text(LocaleKeys.drawer_account.tr()),
            leading: Icon(Icons.account_box),
            onTap: () {
              // Close the drawer and open new screen
              Navigator.popAndPushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: Text(LocaleKeys.drawer_orders.tr()),
            leading: Icon(Icons.monetization_on_rounded),
            onTap: () {
              // Close the drawer and open new screen
              Navigator.popAndPushNamed(context, '/orders');
            },
          ),
          Visibility(
            visible: ModalRoute.of(context).settings.name != "/cart",
            child: ListTile(
              title: Text(LocaleKeys.drawer_cart.tr()),
              leading: Icon(Icons.shopping_cart),
              onTap: () {
                // Close the drawer and open new screen
                Navigator.popAndPushNamed(context, '/cart');
              },
            ),
          ),
          Divider(
            thickness: 3,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: Text(LocaleKeys.drawer_logout.tr()),
            leading: Icon(Icons.logout),
            onTap: () async {
              await _auth.signOut();
              viewModel.logoutUser();

              // Then close the drawer and all screens before the home
              if (ModalRoute.of(context).settings.name != Navigator.defaultRouteName) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
              // If only the drawer is opened, just pop it (popUntil won't work correctly)
              else {
                Navigator.pop(context);
              }


              // display snackbar on home screen
              HomeScreen.scaffoldKey.currentState
                  .showSnackBar(SnackBar(content: Text(LocaleKeys.snackbar_logout.tr())));
            },
          ),
        ]
      : <Widget>[
          ListTile(
            title: Text(LocaleKeys.drawer_login.tr()),
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
