import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realiteye/models/cartItem.dart';

class CartScreenViewModel {

  final List<CartItem> cartItems;
  final Function(DocumentReference) removeFromCartCallback;

  CartScreenViewModel({this.cartItems, this.removeFromCartCallback});

}
