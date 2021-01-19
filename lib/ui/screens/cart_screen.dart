import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/cart_bottom_sheet.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/product_screen_args.dart';
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
    List<CartItem> itemList = StoreProvider.of<AppState>(context, listen: false).state.cartItems;

    //TODO: handle case in which getProductDocument fails
    for(CartItem i in itemList) {
      DocumentSnapshot doc = await getProductDocument(i.productId);
      tempList[i.productId.id] = doc;
    }

    return tempList;
  }

  @override
  void dispose() {
    textControllers.forEach((element) => element.dispose());
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    uid = getUID(context);
    if (uid == null)
      return Container();

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

          if(viewModel.cartItems.isEmpty) return Container();


          return FutureBuilder(
              future: _getDocumentList(),
              builder: (context, data) {
                if(data.hasData) {
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
                            Map<String, dynamic> data = documentList[cartItem.productId.id].data();
                            TextEditingController textQuantityController =
                            TextEditingController(
                                text: cartItem.quantity.toString());
                            textControllers.add(textQuantityController);
                            return  Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (_) {
                                documentList.remove(cartItem.productId.id);
                                viewModel
                                    .removeFromCartCallback(cartItem.productId);
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
                                onTap: () {
                                  Navigator.pushNamed(context, '/product',
                                      arguments: ProductScreenArgs(
                                          cartItem.productId, data));
                                },
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        '${LocaleKeys.quantity.tr()}: ${cartItem.quantity}'),
                                    Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      height: 36.0,
                                      width: 40.0,
                                      child: IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          int newQuantity = cartItem.quantity - 1;
                                          viewModel.changeCartItemQuantityCallback(
                                              CartItem(
                                                  cartItem.productId, newQuantity));
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0.0),
                                      height: 36.0,
                                      width: 40.0,
                                      child:  Focus(
                                        onFocusChange: (focus) {
                                          if (!focus) {
                                            int quantity = int.tryParse(
                                                textQuantityController.text);
                                            if (quantity == null ||
                                                quantity < 1 ||
                                                quantity > 50) {
                                              displaySnackbarWithText(context,
                                                  "The quantity must be between 1 and 50");
                                              textQuantityController.text = cartItem.quantity.toString();
                                            } else {
                                              viewModel
                                                  .changeCartItemQuantityCallback(
                                                  CartItem(
                                                      cartItem.productId,
                                                      quantity));
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
                                              if (quantity < 1 || quantity > 50)
                                                displaySnackbarWithText(context,
                                                    "The quantity must be between 1 and 50");
                                              else
                                                viewModel
                                                    .changeCartItemQuantityCallback(
                                                    CartItem(
                                                        cartItem.productId,
                                                        quantity));
                                            } else {
                                              displaySnackbarWithText(context,
                                                  "The quantity cannot be null");
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
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          int newQuantity = cartItem.quantity + 1;
                                          viewModel.changeCartItemQuantityCallback(
                                              CartItem(
                                                  cartItem.productId, newQuantity));
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
                      SizedBox(height: 10,),
                      Text("Loading")
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
        return CartBottomSheet(StoreProvider.of<AppState>(context).state.cartItems, documentList, uid);
      },
    );
  }

}
