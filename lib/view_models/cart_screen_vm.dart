import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realiteye/models/cart_item.dart';

class CartScreenViewModel {

  final List<CartItem> cartItems;
  final Function(CartItem) changeCartItemQuantityCallback;
  final Function(DocumentReference) removeFromCartCallback;

  CartScreenViewModel({this.cartItems, this.removeFromCartCallback, this.changeCartItemQuantityCallback});

}
