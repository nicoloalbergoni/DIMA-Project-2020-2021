import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/ui/widgets/product_card.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/search_filters.dart';
import 'package:realiteye/utils/utils.dart';

final CollectionReference products = FirebaseFirestore.instance.collection('products');

class SearchListViewBuilder extends StatefulWidget {

  final SearchFilters _searchFilters;
  SearchListViewBuilder(this._searchFilters);

  @override
  _SearchListViewBuilderState createState() => _SearchListViewBuilderState();
}

class _SearchListViewBuilderState extends State<SearchListViewBuilder> {

  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _data = new List<DocumentSnapshot>();

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      //TODO: Style Scrollbar
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          controller: controller,
          itemCount: _data.length + 1,
          itemBuilder: (_, int index) {
            if (index < _data.length) {
              final DocumentSnapshot document = _data[index];
              return ProductCard(document);
            }
            return Center(
              child: Opacity(
                opacity: _isLoading ? 1.0 : 0.0,
                child: SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator()),
              ),
            );
          },
        ),
      ),
      onRefresh: () async{
        _data.clear();
        _lastVisible = null;
        await _getData();
      },
    );
  }

  Future<void> _getData() async {
    QuerySnapshot data = await getSearchQueryResult(_lastVisible, widget._searchFilters.dropdownValue);

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _data.addAll(data.docs);
        });
      }
    } else {
      setState(() => _isLoading = false);
      displaySnackbarWithText(context, "No more items were found");
    }
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }
}