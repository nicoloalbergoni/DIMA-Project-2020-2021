import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode _focus;
  final Function() _performSearch;

  SearchBox(this.controller, this._focus, this._performSearch);


  final OutlineInputBorder _defaultBorderStyle = OutlineInputBorder(
      borderSide: BorderSide(width: 0.2, color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(10)));

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: _focus,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _performSearch(),
      decoration: InputDecoration(
          fillColor: Colors.grey.withOpacity(0.2),
          filled: true,
          hintText: 'Search',
          enabledBorder: _defaultBorderStyle,
          border: _defaultBorderStyle,
          suffixIcon: IconButton(onPressed: _performSearch, icon: Icon(Icons.search))),
    );
  }
}
