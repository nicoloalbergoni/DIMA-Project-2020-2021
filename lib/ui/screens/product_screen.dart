import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/discount_chip.dart';
import 'package:realiteye/ui/widgets/firebase_doc_future_builder.dart';
import 'package:realiteye/ui/widgets/image_carousel.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/utils.dart';
import 'package:realiteye/view_models/product_screen_appbar_vm.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // contains only field productId, of type DocumentReference
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    return StoreConnector<AppState, ProductScreenAppbarViewModel>(
      converter: (store) {
        return ProductScreenAppbarViewModel(
          firebaseUser: store.state.firebaseUser,
          cartItems: store.state.cartItems,
          addToCartCallback: (cartItem) => store.dispatch(AddCartItemAction(cartItem)),
          removeFromCartCallback: (productId) => store.dispatch(RemoveCartItemAction(productId))
        );
      },
      builder: (context, viewModel) {
        return Scaffold(
          appBar: CustomAppBar(
            LocaleKeys.product_title.tr(),
            additionalActions: [
              Builder(builder: (context) =>
                  _buildCartAction(args['productId'], viewModel, context),
              ),
            ],
          ),
          drawer: SideMenu(),
          body: FirebaseDocFutureBuilder(
              getProductDocument(args['productId']),
                  (data) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Flexible(
                          child: ImageCarousel(data['images']),
                          flex: 1
                      ),
                      Flexible(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('${data['name']}',
                                        style: Theme.of(context).textTheme.headline5
                                    ),
                                    Spacer(flex: 1,),
                                    RatingBarIndicator(
                                      rating: 4.4,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 16.0,
                                      direction: Axis.horizontal,
                                    ),
                                    Text('1234',
                                      style: Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text('${LocaleKeys.price.tr()}:'
                                        ' ${computePriceString(
                                        data['price'] / 1.0,
                                        data['discount'])}\$'),
                                    SizedBox(width: 20,),
                                    DiscountChip(data['discount']),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Chip(
                                //       avatar: Icon(Icons.shopping_bag),
                                //       label: Text('On sale'),
                                //     ),
                                //     SizedBox(width: 10,),
                                //     Chip(
                                //       avatar: Icon(Icons.card_giftcard),
                                //       label: Text('Gifts'),
                                //     )
                                //   ],
                                // ),
                                SizedBox(height: 50,
                                  child: ListView.separated(
                                    itemCount: data['categories'].length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Chip(
                                        avatar: Icon(Icons.shopping_bag),
                                        label: Text('${data['categories'][index]}'),
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) =>
                                        SizedBox(width: 6,),
                                  ),
                                ),
                                SizedBox(height: 16,),
                                Text('${data['description']}')
                              ]
                          ),
                          flex: 2
                      ),
                    ],
                  ),
                );
              }
          ),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                // Add your onPressed code here!
              },
              label: Text('${LocaleKeys.product_AR.tr()}'),
              icon: Icon(Icons.visibility)
          ),
        );
      },
    );
  }
}

Widget _buildCartAction(DocumentReference productId,
    ProductScreenAppbarViewModel vm, BuildContext context) {
  if (vm.firebaseUser == null) {
    return Container();
  }
  else {
    return (vm.cartItems.any((item) => item.productId == productId))
        ? IconButton(icon: Icon(Icons.remove_shopping_cart),
            onPressed: () {
              vm.removeFromCartCallback(productId);
              displaySnackbarWithText(context, 'Product removed from cart');
            })
        : IconButton(icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              vm.addToCartCallback(CartItem(productId, 1));
              displaySnackbarWithText(context, 'Product added to cart');
            });
  }
}
