import 'package:flutter/material.dart';

class DiscountChip extends StatelessWidget {
  final int discount;
  final double fontSize;
  DiscountChip(this.discount, {this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
      return Chip(
        backgroundColor: Colors.black,
        // avoid hardcoded min height=32
        labelPadding: EdgeInsets.symmetric(vertical: -5.0, horizontal: 2.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          '$discount% OFF',
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSize
          ),
        ),
      );
  }
}
