import 'package:flutter/material.dart';

class SingleCardPageList extends StatefulWidget {
  final List<Object> items;
  final Widget Function(Map<String, dynamic> data) buildCardContent;
  final double cardHeight;

  SingleCardPageList(this.items, this.buildCardContent, {this.cardHeight = 50.0});

  @override
  _SingleCardPageListState createState() => _SingleCardPageListState();
}

class _SingleCardPageListState extends State<SingleCardPageList> {
  int _actualIndex = 0;

  void _setActualIndex(int index) {
    setState(() {
      _actualIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.cardHeight,
          width: double.infinity,
          child: Card(
            child: Padding(
                padding: EdgeInsets.all(6.0),
                child: widget.buildCardContent(widget.items[_actualIndex])
            ),
          ),
        ),
        SizedBox(height: 6,),
        SizedBox(
          height: 20,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context, int index) {
                return RaisedButton(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(decoration: (index == _actualIndex)
                        ? TextDecoration.underline : TextDecoration.none),
                  ),
                  onPressed: () => _setActualIndex(index),
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 6,),
            ),
          ),
        )
      ],
    );
  }
}
