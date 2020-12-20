import 'package:flutter/material.dart';

import 'home_product_card.dart';

class HomeProductShowcase extends StatelessWidget {
  final String title;
  final List testList;

  HomeProductShowcase(this.title, this.testList);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline4,
        ),
        Expanded(child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: testList.length,
            itemBuilder: (BuildContext context, int index) {
              return HomeProductCard();
            }
        )),
      ],
    );
  }
}
