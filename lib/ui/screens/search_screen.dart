import 'package:flutter/material.dart';
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
  bool hasFocus = false;
  bool showSearchResult = false;

  _SearchScreenState() {
    _searchController.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Product Search"),
      drawer: SideMenu(),
      body: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          children: [
            SearchBox(_searchController, _searchFocus, _searchPressed),
            (hasFocus || history.length == 0)
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
          onTap: () => _searchController.text = history[index],
          leading: Icon(Icons.history),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    history = ["Item 1", "Item 2"];
    _searchFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      if (_searchFocus.hasFocus) {
        hasFocus = true;
        showSearchResult = false;
      } else {
        hasFocus = false;
      }
    });
  }

  void _searchPressed() {
    setState(() {
      if (_searchController.text.isNotEmpty && !history.contains(_searchController.text))
        history.add(_searchController.text);
      
      _searchFocus.unfocus();
      _searchController.clear();
      hasFocus = false;
      showSearchResult = true;
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
