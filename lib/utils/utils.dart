import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/redux/app_state.dart';

bool validateEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

void displaySnackbarWithText(BuildContext context, String message) {
  Scaffold.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
        content: Text(message)
    ));
}

String getUID(BuildContext context) {
  return StoreProvider.of<AppState>(context).state.firebaseUser.uid;
}

String formatDate(Timestamp ts) {
  DateTime date = ts.toDate();
  return DateFormat('dd/MM/yyyy').format(date);
}

String computePriceString(double price, int discount) {
  double discountedPrice = price * (1 - (discount / 100));
  return discountedPrice.toStringAsFixed(2);
}