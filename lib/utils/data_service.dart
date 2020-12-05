import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

// Create a CollectionReference called users that references the firestore collection
CollectionReference users = FirebaseFirestore.instance.collection('users');

Stream<QuerySnapshot> getUsers() {
  // Call the user's CollectionReference to add a new user
  return users.snapshots();
}