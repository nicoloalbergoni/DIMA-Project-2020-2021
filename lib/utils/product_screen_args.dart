import 'package:cloud_firestore/cloud_firestore.dart';

class ProductScreenArgs {
  final DocumentReference productId;
  final Map<String, dynamic> data;

  ProductScreenArgs(this.productId, this.data);
}