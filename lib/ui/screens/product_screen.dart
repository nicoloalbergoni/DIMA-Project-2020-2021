import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/image_carousel.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';

import '../../generated/locale_keys.g.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(LocaleKeys.title),
        drawer: SideMenu(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
            children: [
              Flexible(
                  child: ImageCarousel(),
                  flex: 1
              ),
              Flexible(
                  child: Column(
                      children: [
                        Row(
                          children: [
                            Text('A product name',
                                style: Theme.of(context).textTheme.headline5
                            ),
                            Spacer(flex: 1,),
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
                                style: Theme.of(context).textTheme.caption)
                          ],
                        ),
                        Row(
                          children: [
                            Text('Price: 99.99\$'),
                            SizedBox(width: 20,),
                            Chip(
                              backgroundColor: Colors.black,
                              label: Text(
                                '20% OFF',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Chip(
                              avatar: Icon(Icons.shopping_bag),
                              label: Text('On sale'),
                            ),
                            SizedBox(width: 10,),
                            Chip(
                              avatar: Icon(Icons.card_giftcard),
                              label: Text('Gifts'),
                            )
                          ],
                        ),
                        Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                            ' Suspendisse quis metus at libero gravida egestas quis sit amet arcu.'
                            ' Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla facilisi.'
                            ' Pellentesque in faucibus nisl. Suspendisse et enim cursus, vehicula.')
                      ]
                  ),
                  flex: 2
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // Add your onPressed code here!
            },
            label: Text('View in AR'),
            icon: Icon(Icons.visibility)
        ),
    );
  }
}
