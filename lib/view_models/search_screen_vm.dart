import 'package:flutter/material.dart';

@immutable
class SearchScreenViewModel {
  final List<String> searchHistory;
  final Function(String) addHistoryItemCallback;

  SearchScreenViewModel({this.searchHistory, this.addHistoryItemCallback});
}