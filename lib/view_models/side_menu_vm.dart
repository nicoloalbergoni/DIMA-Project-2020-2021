import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class SideMenuViewModel {
  final ThemeMode theme;
  final User firebaseUser;

  final Function(ThemeMode) switchThemeCallback;
  final Function() logoutUser;

  SideMenuViewModel({this.theme, this.firebaseUser,
    this.switchThemeCallback, this.logoutUser});
}