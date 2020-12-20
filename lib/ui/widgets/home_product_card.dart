import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'discount_chip.dart';

class HomeProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
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
              SizedBox(height: 5,),
              Text('Product name',
                style: Theme.of(context).textTheme.subtitle2,
              ),
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
              Text('49.99\$'),
              SizedBox(height: 4,),
              Row(
                children: [
                  Text('99.99\$',
                      style: TextStyle(decoration: TextDecoration.lineThrough)),
                  SizedBox(width: 10,),
                  DiscountChip(50, fontSize: 11,)
                ],
              ),
            ],
          ),
        )
    );
  }
}
