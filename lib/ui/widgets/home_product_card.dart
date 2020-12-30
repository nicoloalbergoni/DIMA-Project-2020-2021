import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:realiteye/utils/utils.dart';

import 'discount_chip.dart';

class HomeProductCard extends StatelessWidget {
  final String productName;
  final double price;
  final int discount;
  final DocumentReference productId;

  HomeProductCard(this.productName, this.price, this.discount, this.productId);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 131,
      child: Card(
        child: InkWell(
          splashColor: Colors.green.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, '/product',
                arguments: { 'productId': productId });
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 100,
                  color: Colors.green,
                ),
                SizedBox(height: 6,),
                Text(productName,
                  style: Theme.of(context).textTheme.subtitle2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2,),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: 4.4,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 16.0,
                      direction: Axis.horizontal,
                    ),
                    Text('1234',
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
                SizedBox(height: 8,),
                Text('${computePriceString(price, discount)}\$'),
                SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$price\$',
                        style: TextStyle(decoration: TextDecoration.lineThrough)),
                    DiscountChip(discount, fontSize: 10,)
                  ],
                ),
              ],
            ),
          ),
          )
      ),
    );
  }
}
