import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cart_item.dart';
import 'package:realiteye/models/product_screen_args.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/discount_chip.dart';
import 'package:realiteye/ui/widgets/image_carousel.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';
import 'package:realiteye/utils/downloader.dart';
import 'package:realiteye/utils/utils.dart';
import 'package:realiteye/view_models/product_screen_appbar_vm.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // contains only field productId, of type DocumentReference
    final ProductScreenArgs args = ModalRoute.of(context).settings.arguments;

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
                  _buildCartAction(args.productId, viewModel, context),
              ),
            ],
          ),
          drawer: SideMenu(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200.0 + 28.0, // 200 image carousel, 28 indicators
                  child: ImageCarousel(args.data['images'], height: 200.0,),
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(args.data['name'],
                            style: Theme.of(context).textTheme.headline5
                        ),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: args.data['rating'] / 1.0,
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
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Text('${LocaleKeys.price.tr()}:'
                                ' ${computePriceString(
                                args.data['price'] / 1.0,
                                args.data['discount'])}\$'),
                            SizedBox(width: 20,),
                            DiscountChip(args.data['discount']),
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
                            itemCount: args.data['categories'].length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              String category = args.data['categories'][index];
                              String categoryKey = 'categories_${category.toLowerCase()}';

                              return Chip(
                                // TODO: add a category-icon map?
                                avatar: Icon(Icons.shopping_bag),
                                label: Text(categoryKey.tr()),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                                SizedBox(width: 6,),
                          ),
                        ),
                        SizedBox(height: 16,),
                        Text(args.data['description'])
                      ]
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: (args.data['has_AR'])
            ? FloatingActionButton.extended(
                onPressed: () async {
                  String bundlePath = await downloadUnityBundle(args.data['ar_package']);
                  Navigator.pushNamed(context, '/unity',
                      arguments: {'bundlePath': bundlePath});
                },
                label: Text(LocaleKeys.product_AR.tr()),
                icon: Icon(Icons.visibility)
              )
            : FloatingActionButton.extended(
              onPressed: null,
              label: Text(LocaleKeys.product_no_AR.tr()),
              backgroundColor: Theme.of(context).disabledColor,
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
              displaySnackbarWithText(context, LocaleKeys.snackbar_cart_remove.tr());
            })
        : IconButton(icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              vm.addToCartCallback(CartItem(productId, 1));
              displaySnackbarWithText(context, LocaleKeys.snackbar_cart_add.tr());
            });
  }
}
