import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/models/cart_item.dart';

@immutable
class AppState {
  final User firebaseUser;
  final List<CartItem> cartItems;
  final ThemeMode theme;
  final List<String> searchHistory;

  final bool isFetching;
  final Exception error;

  AppState({this.cartItems, this.firebaseUser, this.theme, this.searchHistory,
        this.isFetching = false, this.error});

  AppState copyWith({User firebaseUser, List<CartItem> cartItems,
                    ThemeMode theme, List<String> searchHistory,
                    bool isFetching, Exception error}) {
    return new AppState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        cartItems: cartItems ?? this.cartItems,
        theme: theme ?? this.theme,
        searchHistory: searchHistory ?? this.searchHistory,
        isFetching: isFetching ?? this.isFetching,
        error: error ?? this.error
    );
  }
}