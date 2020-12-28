import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseQueryFutureBuilder extends StatelessWidget {
  final Future<QuerySnapshot> future;
  final Widget Function(DocumentReference, Map<String, dynamic>) dataWidget;
  final Axis listScrollDirection;

  FirebaseQueryFutureBuilder(this.future, this.dataWidget, {this.listScrollDirection = Axis.vertical});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
              scrollDirection: listScrollDirection,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentReference docId = snapshot.data.docs[index].reference;
                Map<String, dynamic> data = snapshot.data.docs[index].data();

                return dataWidget(docId, data);
              }
          );
        });
  }
}
