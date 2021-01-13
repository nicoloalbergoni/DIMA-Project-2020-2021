import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realiteye/ui/widgets/home_product_card.dart';

import 'firebase_query_future_builder.dart';

class HomeProductShowcase extends StatelessWidget {
  final String title;
  final Future<QuerySnapshot> future;

  HomeProductShowcase(this.title, this.future);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          height: 214,
          width: double.infinity,
          child: FirebaseQueryFutureBuilder(
            future,
                (docId, data) {
              return HomeProductCard(data, docId);
            },
            listScrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}
