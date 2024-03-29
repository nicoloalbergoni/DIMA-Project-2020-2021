import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:realiteye/models/product_screen_args.dart';
import 'package:realiteye/ui/widgets/discount_chip.dart';
import 'package:realiteye/utils/utils.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot productDocument;

  ProductCard(this.productDocument);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          splashColor: Colors.green.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, '/product',
                arguments: ProductScreenArgs(productDocument.reference, productDocument.data()));
          },
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    height: 120,
                    width: 120,
                    child: Image.network(
                      productDocument['thumbnail'],
                      fit: BoxFit.cover,
                      loadingBuilder: onImageLoad,
                      errorBuilder: onImageError,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(productDocument['name'],
                          style: Theme.of(context).textTheme.headline5),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: double.parse(productDocument['rating'].toString()),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 16.0,
                            direction: Axis.horizontal,
                          ),
                          Text(
                            '1234',
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        productDocument['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${computePriceString(productDocument['price'] / 1.0, productDocument['discount'])}\$',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          DiscountChip(productDocument['discount'])
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
