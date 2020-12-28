import 'package:flutter/material.dart';

class SingleCardPageList extends StatelessWidget {
  final List<Object> items;
  final Widget Function(Map<String, dynamic> data) buildCardContent;
  final double cardHeight;

  SingleCardPageList(this.items, this.buildCardContent, this.cardHeight);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: cardHeight,
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: buildCardContent(items[0])
            ),
          ),
        ),
        SizedBox(height: 6,),
        SizedBox(
          height: 20,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return RaisedButton(
                    child: Text('${index + 1}'),
                    // TODO
                    onPressed: null
                );
              }
          ),
        )
      ],
    );
  }
}
