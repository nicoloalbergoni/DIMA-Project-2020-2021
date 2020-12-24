import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDocFutureBuilder extends StatelessWidget {
  final Future<DocumentSnapshot> future;
  final Widget Function(Map<String, dynamic>) dataWidget;


  FirebaseDocFutureBuilder(this.future, this.dataWidget);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: future,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return dataWidget(snapshot.data.data());
        });
  }
}
