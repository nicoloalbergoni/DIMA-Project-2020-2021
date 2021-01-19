import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/utils/search_filters.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Create a CollectionReference called users that references the firestore collection
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
final CollectionReference products =
    FirebaseFirestore.instance.collection('products');

final int queryLimit = 5;
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

Map<String, bool> orderDict = {
  LocaleKeys.filter_cheapest_first: false,
  LocaleKeys.filter_expensive_first: true,
};

Future<List<DocumentSnapshot>> getSearchQueryResult(
    SearchFilters searchFilters, DocumentSnapshot lastVisible) async {
  QuerySnapshot queryResult;
  List<DocumentSnapshot> documentList = [];
  List<String> selectedCategories = [];

  searchFilters.categoriesBool.forEach((key, value) {
    if (value) selectedCategories.add(key);
  });

  Query baseQuery = products
      .where("discounted_price",
          isGreaterThanOrEqualTo: searchFilters.priceRangeValues.start)
      .where("discounted_price",
          isLessThanOrEqualTo: searchFilters.priceRangeValues.end)
      .orderBy("discounted_price",
          descending: orderDict[searchFilters.dropdownValue]);

  if (searchFilters.showAROnly)
    baseQuery = baseQuery.where("has_AR", isEqualTo: true);

  if (selectedCategories.length > 0)
    baseQuery =
        baseQuery.where("categories", arrayContainsAny: selectedCategories);

  do {
    if (lastVisible == null)
      queryResult = await baseQuery.limit(queryLimit).get();
    else
      queryResult = await baseQuery
          .startAfterDocument(lastVisible)
          .limit(queryLimit)
          .get();

    if (queryResult.docs.length == 0) break;

    documentList.addAll(queryResult.docs.where((element) {
      String productName = element.data()['name'].toString().toLowerCase();
      return productName.contains(searchFilters.queryText.toLowerCase());
    }).toList());

    lastVisible = queryResult.docs.last;
  } while (documentList.length < queryLimit);

  return documentList;
}

/// Add an order from user's cart items
Future<void> addOrderFromCartData(String uid, List<CartItem> cartItem,
    Map<String, DocumentSnapshot> cartDocuments, double totalPrice, String deliveryAddress) async {

  Map<String, dynamic> orderData = {
    'in_progress': true,
    'issue_date': DateTime.now(),
    'delivery_date': DateTime.now().add(Duration(days: 14)),
    'total_cost': totalPrice,
    'delivery_address': deliveryAddress
  };

  DocumentSnapshot user = await users.doc(uid).get();

  // Create order, add order data and get its document reference
  DocumentReference order =
      await user.reference.collection('orders').add(orderData);

  // Add each cart item object as a doc
  cartItem.forEach((item) async {
    Map<String, dynamic> itemMap = {
      'product_id': item.productId,
      'quantity': item.quantity,
      'item_cost': cartDocuments[item.productId.id].data()['discounted_price']
    };
    await order.collection('orderItems').add(itemMap);
  });

  //Delete the items from the remote cart
  await updateUserCart(uid, []);
}

/// Update user's cart items in the database
Future<void> updateUserCart(String uid, List<CartItem> cartData) async {
  DocumentSnapshot user = await users.doc(uid).get();

  // Get all documents in cart
  QuerySnapshot dbCartItems = await user.reference.collection('cart').get();

  // Delete all previous documents (cart items)
  dbCartItems.docs.forEach((doc) async {
    await user.reference.collection('cart').doc(doc.id).delete();
  });

  // Add each cart item object as a doc
  cartData.forEach((item) async {
    Map<String, dynamic> itemMap = {
      'product_id': item.productId,
      'quantity': item.quantity
    };
    await user.reference.collection('cart').add(itemMap);
  });

  print('Cart updated correctly');
}
