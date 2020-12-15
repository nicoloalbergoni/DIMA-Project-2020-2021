import 'package:flutter/material.dart';

@immutable
class SideMenuViewModel {
  final ThemeMode theme;
  final Function(ThemeMode) switchThemeCallback;

  SideMenuViewModel({this.theme, this.switchThemeCallback});
}