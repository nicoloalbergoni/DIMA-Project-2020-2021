import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  DocumentReference productId;
  int quantity;

  CartItem(this.productId, this.quantity);
}