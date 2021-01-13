import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/downloader.dart';

class DebugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(LocaleKeys.title.tr(), showCartIcon: true),
        drawer: SideMenu(),
        body: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, state) {
              return Center(
                  child: Column(
                    children: [
                      FlatButton(
                        child: Text('Open Unity'),
                        onPressed: () async {
                          String path = await downloadUnityBundle('AssetBundles/capsule');
                          Navigator.pushNamed(context, '/unity',
                            arguments: {'bundlePath': path});
                        },
                      ),
                      FlatButton(
                        child: Text('Try redux state change'),
                        onPressed: () {
                          final cartItem = CartItem(null, 5);
                          StoreProvider.of<AppState>(context)
                              .dispatch(AddCartItemAction(cartItem));
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
                      Text('${state.theme}'),
                      Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: getUsers(),
                              builder:
                                  (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text("Loading");
                                }

                                return new ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var document = snapshot.data.docs[index];
                                    return new ListTile(
                                      title: new Text(
                                          "${document.data()['firstname']} ${document.data()['lastname']}"),
                                      subtitle:
                                      new Text(document.data().toString()),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                  const Divider(),
                                );
                              })),
                    ],
                  ));
            })
    );
  }
}
