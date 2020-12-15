import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/data_service.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Cart"),
      drawer: SideMenu(),
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: state.cartItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    CartItem document = state.cartItems[index];
                    return FutureBuilder<DocumentSnapshot>(
                        future: getProductDocument(document.productId),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator());
                          return ListTile(
                            title: Text(snapshot.data.data()['name']),
                            subtitle: new Text(document.quantity.toString()),
                          );
                        });
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text('Buy'),
        icon: Icon(Icons.shopping_cart_rounded)
      ),
    );
  }
}
