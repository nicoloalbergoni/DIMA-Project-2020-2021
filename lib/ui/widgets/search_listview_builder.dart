import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/ui/widgets/product_card.dart';

final CollectionReference products = FirebaseFirestore.instance.collection('products');

class SearchListViewBuilder extends StatefulWidget {
  final List<DocumentSnapshot> _data;
  final Function() getNewDataCallback;
  final Function() refreshDataCallback;

  SearchListViewBuilder(this._data, this.getNewDataCallback, this.refreshDataCallback);

  @override
  _SearchListViewBuilderState createState() => _SearchListViewBuilderState();
}

class _SearchListViewBuilderState extends State<SearchListViewBuilder> {
  ScrollController controller;
  bool _isLoading = false;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      //TODO: Style Scrollbar
      child: Scrollbar(
        child: ListView.builder(
          shrinkWrap: true,
          controller: controller,
          itemCount: widget._data.length + 1,
          itemBuilder: (_, int index) {
            if (index < widget._data.length) {
              final DocumentSnapshot document = widget._data[index];
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
      onRefresh: () async {
        if (!_isLoading) {
          setState(() => _isLoading = true);
          await widget.refreshDataCallback();
        }
      },
    );
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() async {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        await widget.getNewDataCallback();
        setState(() => _isLoading = false);
      }
    }
  }
}