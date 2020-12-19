import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/ui/widgets/custom_appbar.dart';
import 'package:realiteye/ui/widgets/side_menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(LocaleKeys.title, showCartIcon: true),
        drawer: SideMenu(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // TODO: refine this and refactor it in as a separated custom parametrized widget
            Container(
                child: Column(
                  children: [
                    Text(
                      'Hot Deals',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Row(
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: 100,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 5,),
                                Text('Product name'),
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
                                SizedBox(height: 5,),
                                Text('Price: 99.99\$'),
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                  ],
                )
            ),
            // TODO: should be of same type of group above
            Text(
              'Popular',
              style: Theme.of(context).textTheme.headline4,
            ),

          ],
        )
    );
  }
}
