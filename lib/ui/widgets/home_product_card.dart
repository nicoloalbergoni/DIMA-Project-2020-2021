import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:realiteye/utils/product_screen_args.dart';
import 'package:realiteye/utils/utils.dart';

import 'discount_chip.dart';

class HomeProductCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final DocumentReference productId;

  HomeProductCard(this.data, this.productId);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 131,
      child: Card(
        child: InkWell(
          splashColor: Colors.green.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, '/product',
                arguments: ProductScreenArgs(productId, data));
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 106,
                  //color: Colors.green,
                  child: Image.network(data['thumbnail'], fit: BoxFit.cover,
                    width: 106,
                    loadingBuilder: onImageLoad,
                    errorBuilder: onImageError,
                  ),
                ),
                SizedBox(height: 6,),
                Text(data['name'],
                  style: Theme.of(context).textTheme.subtitle2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2,),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: data['rating'] / 1.0,
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
                Text('${computePriceString(data['price'] / 1.0, data['discount'])}\$'),
                SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${data['price']}\$',
                        style: TextStyle(decoration: TextDecoration.lineThrough)),
                    DiscountChip(data['discount'], fontSize: 10,)
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
