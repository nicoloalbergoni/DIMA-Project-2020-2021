import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
                arguments: {'productId': productDocument.reference});
          },
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://picsum.photos/250?image=9',
                    height: 120.0,
                    width: 120.0,
                    //fit: BoxFit.fill,
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
                        // 'Lorem ipsum dolor   sit amet, consectetur adipiscing elit.'
                        // ' Suspendisse quis metus at libero gravida egestas quis sit amet arcu.'
                        // ' Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla facilisi.'
                        // ' Pellentesque in faucibus nisl. Suspendisse et enim cursus, vehicula.',
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
                            '${computePriceString(double.parse(productDocument['price']), productDocument['discount'])}\$',
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
