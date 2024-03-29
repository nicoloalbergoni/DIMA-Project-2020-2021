import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cart_item.dart';
import 'package:realiteye/models/product_screen_args.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/cart_bottom_sheet.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/utils.dart';
import 'package:realiteye/view_models/cart_screen_vm.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<TextEditingController> textControllers;
  Map<String, DocumentSnapshot> documentList;
  String uid;
  final int maxQuantity = 50;
  final int minQuantity = 1;

  @override
  void initState() {
    super.initState();
    textControllers = [];
    documentList = Map<String, DocumentSnapshot>();

    // getDocumentList().then((value) {
    //   documentList = value;
    //   print(documentList.length);
    // });
  }

  Future<Map<String, DocumentSnapshot>> _getDocumentList() async {
    Map<String, DocumentSnapshot> tempList = Map<String, DocumentSnapshot>();
    List<CartItem> itemList =
        StoreProvider.of<AppState>(context, listen: false).state.cartItems;

    //TODO: handle case in which getProductDocument fails
    for (CartItem i in itemList) {
      DocumentSnapshot doc = await getProductDocument(i.productId);
      tempList[i.productId.id] = doc;
    }

    return tempList;
  }

  void onCartItemQuantityChange(int newQuantity, CartScreenViewModel viewModel,
                                CartItem cartItem, BuildContext context,
                                {TextEditingController controller}) {
    if (newQuantity < minQuantity || newQuantity > maxQuantity) {
      displaySnackbarWithText(context, LocaleKeys.snackbar_quantity_range_error.tr());
      if (controller != null) {
        controller.text = cartItem.quantity.toString();
      }
    }
    else {
      viewModel.changeCartItemQuantityCallback(
          CartItem(cartItem.productId, newQuantity));
    }
  }

  @override
  void dispose() {
    textControllers.forEach((element) => element.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    uid = getUID(context);
    if (uid == null) return Container();

    return Scaffold(
      appBar: CustomAppBar(LocaleKeys.cart_title.tr()),
      drawer: SideMenu(),
      body: StoreConnector<AppState, CartScreenViewModel>(
        converter: (store) {
          return CartScreenViewModel(
            cartItems: store.state.cartItems,
            removeFromCartCallback: (productId) =>
                store.dispatch(RemoveCartItemAction(productId)),
            changeCartItemQuantityCallback: (cartItem) =>
                store.dispatch(ChangeCartItemQuantity(cartItem)),
          );
        },
        builder: (context, viewModel) {
          if (viewModel.cartItems.isEmpty) return Container();

          return FutureBuilder(
              future: _getDocumentList(),
              builder: (context, data) {
                if (data.hasData) {
                  documentList = data.data;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          // padding used for whole list, not for items
                          padding: const EdgeInsets.only(top: 6.0),
                          itemCount: documentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            CartItem cartItem = viewModel.cartItems[index];
                            Map<String, dynamic> data =
                                documentList[cartItem.productId.id].data();
                            TextEditingController textQuantityController =
                                TextEditingController(
                                    text: cartItem.quantity.toString());
                            textControllers.add(textQuantityController);
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (_) {
                                documentList.remove(cartItem.productId.id);
                                viewModel
                                    .removeFromCartCallback(cartItem.productId);
                                displaySnackbarWithText(
                                    context, LocaleKeys.snackbar_cart_remove.tr());
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
                                title: Text(
                                  data['name'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, '/product',
                                      arguments: ProductScreenArgs(
                                          cartItem.productId, data));
                                },
                                subtitle: Text(
                                    "${LocaleKeys.price.tr()}: ${data['discounted_price']}\$"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      height: 36.0,
                                      width: 40.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          //color: Colors.black,
                                        ),
                                        onPressed: () {
                                          int newQuantity =
                                              cartItem.quantity - 1;
                                          onCartItemQuantityChange(newQuantity,
                                              viewModel, cartItem, context);
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      height: 36.0,
                                      width: 40.0,
                                      child: Focus(
                                        onFocusChange: (focus) {
                                          if (!focus) {
                                            int quantity = int.tryParse(
                                                textQuantityController.text);

                                            if (quantity != null) {
                                              onCartItemQuantityChange(quantity,
                                                viewModel, cartItem, context,
                                                controller: textQuantityController);
                                            }
                                            else {
                                              displaySnackbarWithText(context,
                                                  LocaleKeys.snackbar_quantity_error.tr());
                                              textQuantityController.text =
                                                  cartItem.quantity.toString();
                                            }
                                          }
                                        },
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          controller: textQuantityController,
                                          onSubmitted: (value) {
                                            int quantity = int.tryParse(value);

                                            if (quantity != null) {
                                              onCartItemQuantityChange(quantity,
                                                viewModel, cartItem, context,
                                                controller: textQuantityController);
                                            }
                                            else {
                                              displaySnackbarWithText(context,
                                                  LocaleKeys.snackbar_quantity_error.tr());
                                              textQuantityController.text =
                                                  cartItem.quantity.toString();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      height: 36.0,
                                      width: 40.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add_circle,
                                          //color: Colors.black,
                                        ),
                                        onPressed: () {
                                          int newQuantity =
                                              cartItem.quantity + 1;
                                          onCartItemQuantityChange(newQuantity,
                                              viewModel, cartItem, context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      )
                    ],
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(LocaleKeys.loading.tr())
                    ],
                  ),
                );
              });
        },
      ),
      floatingActionButton: Visibility(
        visible: StoreProvider.of<AppState>(context).state.cartItems.isNotEmpty,
        child: FloatingActionButton.extended(

            onPressed: () {
              _showModalBottomSheet(context);
            },
            label: Text(LocaleKeys.cart_buy_button.tr()),
            icon: Icon(Icons.shopping_cart_rounded)),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return CartBottomSheet(
            StoreProvider.of<AppState>(context).state.cartItems,
            documentList,
            uid);
      },
    );
  }
}
