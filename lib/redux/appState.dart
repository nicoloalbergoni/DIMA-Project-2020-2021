import 'package:realiteye/models/cartItem.dart';
import 'package:flutter/material.dart';

class AppState {
  List<CartItem> cartItems;
  AppState(
      {@required this.cartItems});

  AppState.fromAppState(AppState another) {
    this.cartItems = another.cartItems;
  }
}