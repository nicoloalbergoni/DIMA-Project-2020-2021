import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/utils/search_filters.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Create a CollectionReference called users that references the firestore collection
final CollectionReference Function(FirebaseFirestore) users =
    (fireInstance) => fireInstance.collection('users');
final CollectionReference Function(FirebaseFirestore) products =
    (fireInstance) => fireInstance.collection('products');

final int queryLimit = 5;
// TODO: just for testing real time streams, eliminate in future
Stream<QuerySnapshot> getUsers({FirebaseFirestore mockFsInstance}) {
  // Call the user's CollectionReference to add a new user
  return users(mockFsInstance ?? firestore).snapshots();
}

Future<QuerySnapshot> getUserCart(String uid, {FirebaseFirestore mockFsInstance}) async {
  DocumentSnapshot user = await users(mockFsInstance ?? firestore).doc(uid).get();
  return user.reference.collection('cart').get();
}

Future<DocumentSnapshot> getProductDocument(DocumentReference productId, {FirebaseFirestore mockFsInstance}) async {
  return productId.get();
}

// Add a user to the users Firestore collection
void addUser(User user, Map<String, dynamic> userData, {FirebaseFirestore mockFsInstance}) async {
  if (user != null && userData != null) {
    await users(mockFsInstance ?? firestore).doc(user.uid).set(userData);
    print('User ${user.email} correctly registered on the database');
  }
}

Future<DocumentSnapshot> getUserDocument(String uid, {FirebaseFirestore mockFsInstance}) async {
  return users(mockFsInstance ?? firestore).doc(uid).get();
}

Future<QuerySnapshot> getUserInProgressOrders(String uid, {FirebaseFirestore mockFsInstance}) async {
  DocumentSnapshot user = await users(mockFsInstance ?? firestore).doc(uid).get();
  return user.reference
      .collection('orders')
      .where('in_progress', isEqualTo: true)
      .get();
}

Future<QuerySnapshot> getUserCompletedOrders(String uid, {FirebaseFirestore mockFsInstance}) async {
  DocumentSnapshot user = await users(mockFsInstance ?? firestore).doc(uid).get();
  return user.reference
      .collection('orders')
      .where('in_progress', isEqualTo: false)
      .get();
}

Future<QuerySnapshot> getHotDeals({FirebaseFirestore mockFsInstance}) async {
  return products(mockFsInstance ?? firestore).where('hot_deal', isEqualTo: true).get();
}

Future<QuerySnapshot> getPopulars({FirebaseFirestore mockFsInstance}) async {
  return products(mockFsInstance ?? firestore).where('popular', isEqualTo: true).get();
}

Map<String, bool> orderDict = {
  LocaleKeys.filter_cheapest_first: false,
  LocaleKeys.filter_expensive_first: true,
};

Future<List<DocumentSnapshot>> getSearchQueryResult(
    SearchFilters searchFilters, DocumentSnapshot lastVisible, {FirebaseFirestore mockFsInstance}) async {
  QuerySnapshot queryResult;
  List<DocumentSnapshot> documentList = [];
  List<String> selectedCategories = [];

  searchFilters.categoriesBool.forEach((key, value) {
    if (value) selectedCategories.add(key);
  });

  Query baseQuery = products(mockFsInstance ?? firestore)
      .where("discounted_price",
          isGreaterThanOrEqualTo: searchFilters.priceRangeValues.start)
      .where("discounted_price",
          isLessThanOrEqualTo: searchFilters.priceRangeValues.end)
      .orderBy("discounted_price",
          descending: orderDict[searchFilters.orderingKey]);

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
Future<DocumentReference> addOrderFromCartData(String uid, List<CartItem> cartItems,
    Map<String, DocumentSnapshot> cartDocuments, double totalPrice,
    String deliveryAddress, String paymentCard, {FirebaseFirestore mockFsInstance}) async {


  Map<String, dynamic> orderData = {
    'in_progress': true,
    'issue_date': DateTime.now(),
    'delivery_date': DateTime.now().add(Duration(days: 14)),
    'total_cost': double.parse(totalPrice.toStringAsFixed(2)), // This is to fix the double precision to 2 decimals
    'delivery_address': deliveryAddress,
    'payment_card': paymentCard
  };

  DocumentSnapshot user = await users(mockFsInstance ?? firestore).doc(uid).get();

  // Create order, add order data and get its document reference
  DocumentReference order =
      await user.reference.collection('orders').add(orderData);

  // Add each cart item object as a doc
  cartItems.forEach((item) async {
    Map<String, dynamic> itemMap = {
      'product_id': item.productId,
      'quantity': item.quantity,
      'item_cost': cartDocuments[item.productId.id].data()['discounted_price']
    };
    await order.collection('orderItems').add(itemMap);
  });

  //Delete the items from the remote cart
  await updateUserCart(uid, [], mockFsInstance: mockFsInstance);

  return order;
}

/// Update user's cart items in the database
Future<void> updateUserCart(String uid, List<CartItem> cartData, {FirebaseFirestore mockFsInstance}) async {
  DocumentSnapshot user = await users(mockFsInstance ?? firestore).doc(uid).get();

  // Get all documents in cart
  QuerySnapshot dbCartItems = await user.reference.collection('cart').get();

  // Delete all previous documents (cart items)
  dbCartItems.docs.forEach((doc) async {
    await user.reference.collection('cart').doc(doc.id).delete();
  });

  // Add each cart item object as a doc
  cartData.forEach((item) async {
    await user.reference.collection('cart').add(item.asMap());
  });

  print('Cart updated correctly');
}
