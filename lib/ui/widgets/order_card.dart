import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order id: 1234',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text('ordered: 12/04/2020'),
              Text('expected delivery:'),
              SizedBox(height: 6,),
              Align(
                alignment: Alignment.bottomRight,
                child: Text('Total: 19.99\$'),
              )
            ],
          ),
        )
    );
  }
}
