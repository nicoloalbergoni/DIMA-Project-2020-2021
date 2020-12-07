import 'package:firebase_auth/firebase_auth.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:flutter/material.dart';

class AppState {
  final User firebaseUser;
  final List<CartItem> cartItems;
  final ThemeMode theme;

  AppState(
      {@required this.cartItems, this.firebaseUser, this.theme});

  AppState copyWith({User firebaseUser, List<CartItem> cartItems, ThemeMode theme}) {
    return new AppState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        cartItems: cartItems ?? this.cartItems,
        theme: theme ?? this.theme
    );
  }
}