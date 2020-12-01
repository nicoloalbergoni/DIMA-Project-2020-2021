import 'package:firebase_auth/firebase_auth.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:flutter/material.dart';

class AppState {
  final User firebaseUser;
  final List<CartItem> cartItems;
  AppState(
      {@required this.cartItems, this.firebaseUser});

  AppState copyWith({User firebaseUser, List<CartItem> cartItems}) {
    return new AppState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        cartItems: cartItems ?? this.cartItems
    );
  }
}