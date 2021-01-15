import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/firebase_doc_future_builder.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/product_screen_args.dart';
import 'package:realiteye/utils/utils.dart';
import 'package:realiteye/view_models/cart_screen_vm.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(LocaleKeys.cart_title.tr()),
      drawer: SideMenu(),
      body: StoreConnector<AppState, CartScreenViewModel>(
        converter: (store) {
          return CartScreenViewModel(
              cartItems: store.state.cartItems,
              removeFromCartCallback: (productId) =>
                  store.dispatch(RemoveCartItemAction(productId)));
        },
        builder: (context, viewModel) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  // padding used for whole list, not for items
                  padding: const EdgeInsets.only(top: 6.0),
                  itemCount: viewModel.cartItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    CartItem document = viewModel.cartItems[index];
                    return FirebaseDocFutureBuilder(
                      getProductDocument(document.productId),
                      (data) {
                        // TODO: Fix dismissible problem in listview
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (_) {
                            viewModel
                                .removeFromCartCallback(document.productId);
                            displaySnackbarWithText(
                                context, 'Product removed from cart');
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 25),
                            color: Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete, color: Colors.white),
                                Text(
                                  LocaleKeys.cart_dismissible_delete.tr(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          child: ListTile(
                            leading: SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.network(
                                data['thumbnail'],
                                fit: BoxFit.cover,
                                loadingBuilder: onImageLoad,
                                errorBuilder: onImageError,
                              ),
                            ),
                            title: Text(data['name']),
                            subtitle: new Text(
                                '${LocaleKeys.quantity.tr()}: ${document.quantity}'),
                            onTap: () {
                              Navigator.pushNamed(context, '/product',
                                  arguments: ProductScreenArgs(
                                      document.productId, data));
                            },
                          ),
                        );
                      },
                    );
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
          label: Text(LocaleKeys.cart_buy_button.tr()),
          icon: Icon(Icons.shopping_cart_rounded)),
    );
  }
}
