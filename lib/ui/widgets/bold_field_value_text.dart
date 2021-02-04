import 'package:flutter/material.dart';

class BoldFieldValueText extends StatelessWidget {
  final String fieldText, valueText;

  BoldFieldValueText(this.fieldText, this.valueText);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: new TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          new TextSpan(text: fieldText.trim() + ' ', style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: valueText),
        ],
      ),
    );
  }
}
