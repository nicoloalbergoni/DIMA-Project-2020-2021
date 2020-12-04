import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/screens/unity.dart';
import 'package:realiteye/utils/downloader.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.title.tr()),
        ),
        body: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return Center(
                  child: Column(
                children: [
                  FlatButton(
                    child: Text('Open Unity'),
                    onPressed: () async {
                      String path = await downloadFromURL(
                          'http://192.168.1.5:8000/capsule');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UnityScreen(bundlePath: path)));
                    },
                  ),
                  FlatButton(
                    child: Text('Try redux state change'),
                    onPressed: () {
                      final cartItem = CartItem("a", true);
                      StoreProvider.of<AppState>(context)
                          .dispatch(AddItemAction(cartItem));
                    },
                  ),
                  Text("Cart items count: ${state.cartItems.length}"),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: Text("Login Page")),
                  state.firebaseUser == null
                      ? Text("Current user is null")
                      : Text("${state.firebaseUser}"),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: Text("Sign Up"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      print(context.locale.countryCode);
                      context.locale = context.locale == Locale('en', 'US') ? Locale('it', 'IT') : Locale('en', 'US');
                      print(context.locale.countryCode);
                    },
                    child: Text('Change language'),
                  )
                ],
              ));
            }));
  }
}
