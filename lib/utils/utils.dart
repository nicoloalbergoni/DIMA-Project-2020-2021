import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  User user = StoreProvider.of<AppState>(context).state.firebaseUser;
  return (user != null) ? user.uid : null;
}

String formatDate(Timestamp ts) {
  DateTime date = ts.toDate();
  return DateFormat('dd/MM/yyyy').format(date);
}

String computePriceString(double price, int discount) {
  double discountedPrice = price * (1 - (discount / 100));
  return discountedPrice.toStringAsFixed(2);
}

Widget onImageLoad(BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
  if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null ?
      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
          : null,
    ),
  );
}

Widget onImageError(BuildContext context, Object error, StackTrace stackTrace) {
  return Image.asset('assets/images/image-not-found.jpg', fit: BoxFit.cover);
}