import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/search_box.dart';
import 'package:realiteye/ui/widgets/search_listview_builder.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  List history;
  bool showHistory;
  bool showSearchResult;

  @override
  void initState() {
    super.initState();
    showHistory = false;
    showSearchResult = false;
    history = ["Item 1", "Item 2"];
    _searchFocus.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(LocaleKeys.search_title.tr()),
      drawer: SideMenu(),
      body: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          children: [
            SearchBox(_searchController, _searchFocus, _searchPressed),
            (showHistory || history.length == 0)
                ? Flexible(child: _buildHistoryList())
                : Container(),
            showSearchResult ? Expanded(child: SearchListViewBuilder()) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(history[index]),
          onTap: () {
            _searchController.text = history[index];
            _searchPressed();
          },
          leading: Icon(Icons.history),
        );
      },
    );
  }

  //TODO: Handle display of search results when unfocus
  void _onFocusChange() {
    setState(() {
      if (_searchFocus.hasFocus) {
        showHistory = true;
        showSearchResult = false;
      } else {
        //showSearchResult = true;
        showHistory = false;
      }
    });
  }

  void _searchPressed() {
    setState(() {
      if (_searchController.text.isNotEmpty && !history.contains(_searchController.text))
        history.add(_searchController.text);

      _searchFocus.unfocus();
      //_searchController.clear();
      showHistory = false;
      showSearchResult = _searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }
}