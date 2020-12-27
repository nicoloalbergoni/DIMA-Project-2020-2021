import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseQueryFutureBuilder extends StatelessWidget {
  final Future<QuerySnapshot> future;
  final Widget Function(String, Map<String, dynamic>) dataWidget;

  FirebaseQueryFutureBuilder(this.future, this.dataWidget);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String docId = snapshot.data.docs[index].id;
                Map<String, dynamic> data = snapshot.data.docs[index].data();

                return dataWidget(docId, data);
              }
          );
        });
  }
}