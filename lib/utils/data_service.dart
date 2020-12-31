import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/utils/search_filters.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Create a CollectionReference called users that references the firestore collection
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
final CollectionReference products =
    FirebaseFirestore.instance.collection('products');

// TODO: just for testing real time streams, eliminate in future
Stream<QuerySnapshot> getUsers() {
  // Call the user's CollectionReference to add a new user
  return users.snapshots();
}

Future<QuerySnapshot> getUserCart(String uid) async {
  DocumentSnapshot user = await users.doc(uid).get();
  return user.reference.collection('cart').get();
}

Future<DocumentSnapshot> getProductDocument(DocumentReference productId) async {
  return products.doc(productId.id).get();
}

// Add a user to the users Firestore collection
void addUser(User user, Map<String, dynamic> userData) async {
  if (user != null && userData != null) {
    await users.doc(user.uid).set(userData);
    print('User ${user.email} correctly registered on the database');
  }
}

Future<DocumentSnapshot> getUserDocument(String uid) async {
  // TODO: Handle error cases
  return users.doc(uid).get();
}

Future<QuerySnapshot> getUserInProgressOrders(String uid) async {
  DocumentSnapshot user = await users.doc(uid).get();
  return user.reference
      .collection('orders')
      .where('in_progress', isEqualTo: true)
      .get();
}

Future<QuerySnapshot> getUserCompletedOrders(String uid) async {
  DocumentSnapshot user = await users.doc(uid).get();
  return user.reference
      .collection('orders')
      .where('in_progress', isEqualTo: false)
      .get();
}

Future<QuerySnapshot> getHotDeals() async {
  return products.where('hot_deal', isEqualTo: true).get();
}

Future<QuerySnapshot> getPopulars() async {
  return products.where('popular', isEqualTo: true).get();
}

Map<String, Map<String, dynamic>> orderDict = {
  LocaleKeys.filter_newest_first: {
    "orderField": "created_at",
    "descending": true
  },
  LocaleKeys.filter_cheapest_first: {
    "orderField": "discounted_price",
    "descending": false
  },
  LocaleKeys.filter_expensive_first: {
    "orderField": "discounted_price",
    "descending": true
  },
};

Future<QuerySnapshot> getSearchQueryResult(
    SearchFilters searchFilters, DocumentSnapshot lastVisible) async {
  Map<String, dynamic> orderObj = orderDict[searchFilters.dropdownValue];
  String capitalizedQueryText = searchFilters.queryText[0].toUpperCase() +
      searchFilters.queryText.substring(1);

  print(searchFilters.priceRangeValues.start);
  print(searchFilters.priceRangeValues.end);

  Query baseQuery = products
      .where("discounted_price",
          isGreaterThanOrEqualTo: searchFilters.priceRangeValues.start)
      .where("discounted_price", isLessThanOrEqualTo: searchFilters.priceRangeValues.end)
      .orderBy(orderObj["orderField"], descending: orderObj["descending"]);

  //.where("name", isGreaterThan: capitalizedQueryText)
  //.where("name", isLessThan: capitalizedQueryText + 'z')
  print(searchFilters.showAROnly);
  if(searchFilters.showAROnly) baseQuery = baseQuery.where("has_AR", isEqualTo: true);

  if (lastVisible == null)
    return await baseQuery.limit(5).get();
  else
    return await baseQuery.startAfterDocument(lastVisible).limit(5).get();
}
