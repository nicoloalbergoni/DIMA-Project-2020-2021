import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/models/cart_item.dart';

class AddCartItemAction {
  final CartItem item;

  AddCartItemAction(this.item);
}

class RemoveCartItemAction {
  final DocumentReference productId;

  RemoveCartItemAction(this.productId);
}

class ClearCartItemList {

 ClearCartItemList();
}

class ChangeCartItemQuantity {
  final CartItem item;

  ChangeCartItemQuantity(this.item);
}

class ChangeFirebaseUserAction {
  final User firebaseUser;

  ChangeFirebaseUserAction(this.firebaseUser);
}

class SwitchThemeAction {
  final ThemeMode theme;

  SwitchThemeAction(this.theme);
}

class AddHistoryItemAction {
  final String searchedString;

  AddHistoryItemAction(this.searchedString);
}

class FetchCartAction {}

class FetchCartSucceededAction {
  final List<CartItem> fetchedCartItems;

  FetchCartSucceededAction(this.fetchedCartItems);
}

class FetchCartFailedAction {
  final Exception error;

  FetchCartFailedAction(this.error);
}

class FirebaseLogoutAction {
  FirebaseLogoutAction();
}