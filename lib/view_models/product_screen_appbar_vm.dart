import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realiteye/models/cart_item.dart';

class ProductScreenAppbarViewModel {
  final User firebaseUser;
  final List<CartItem> cartItems;
  final Function(CartItem) addToCartCallback;
  final Function(DocumentReference) removeFromCartCallback;

  ProductScreenAppbarViewModel({this.firebaseUser, this.cartItems,
    this.addToCartCallback, this.removeFromCartCallback});
}