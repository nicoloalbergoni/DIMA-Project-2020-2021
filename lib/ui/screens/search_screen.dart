import 'package:flutter/material.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/product_card.dart';
import 'package:realiteye/ui/widgets/search_listview_builder.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';

class SearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Product Search"),
      drawer: SideMenu(),
      body: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: SearchListViewBuilder()),
          ],
        ),
      )
    );
  }
}
