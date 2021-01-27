import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/models/cart_item.dart';
import 'package:realiteye/models/search_filters.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:test/test.dart';

import 'utils/document_snapshot_matcher.dart';
import 'utils/query_snapshot_matcher.dart';

MockFirestoreInstance instance;
Map<String, dynamic> prodData;
Map<String, dynamic> userData;
Map<String, dynamic> orderData;

Map<String, DocumentReference> prodRefs;
Map<String, DocumentReference> userRefs;
List<Map<String, dynamic>> priceOrderedProds;

Map<String, dynamic> cartItem = {
  'product_id': prodRefs['p0'],
  'quantity': 4
};

Future<Map<String, dynamic>> loadJsonData(String path) {
  return new File(path)
      .readAsString()
      .then((fileContents) => jsonDecode(fileContents));
}

bool satisfyPriceRange(DocumentSnapshot doc, int min, int max) {
  double price = doc.data()['discounted_price'];
  return price >= min && price <= max;
}

bool satisfyQueryText(DocumentSnapshot doc, String query) {
  return (doc.data()['name'] as String).toLowerCase().contains(query);
}

bool satisfyCategories(DocumentSnapshot doc, List<String> categories) {
  // cast to List<String> not allowed by dart, but is actually a list of strings
  return (doc.data()['categories'] as List<dynamic>)
      .any((el) => categories.any((cat) => cat == el));
}

void main() {
  setUpAll(() async{
    prodData = await loadJsonData(p.join('data', 'products.json'));
    userData = await loadJsonData(p.join('data', 'users.json'));
    // only two orders now: o0 in progress, o1 completed
    orderData = await loadJsonData(p.join('data', 'orders.json'));

    priceOrderedProds = prodData.values.cast<Map<String, dynamic>>().toList();
    priceOrderedProds.sort((a, b) =>
        (a['discounted_price'] as double).compareTo(b['discounted_price'] as double));
  });

  // Executed before each test, reset the mock to a predefined db instance,
  // avoiding test side-effects from influencing the successive ones.
  setUp(() async {
    instance = MockFirestoreInstance();
    prodRefs = {};
    userRefs = {};

    for (var entry in prodData.entries) {
      DocumentReference ref = await instance.collection('products').add(entry.value);
      prodRefs.addAll({
        entry.key: ref,
      });
    }

    for (var entry in userData.entries) {
      DocumentReference ref = await instance.collection('users').add(entry.value);
      userRefs.addAll({
        entry.key: ref,
      });

      await userRefs[entry.key].collection('cart').add(cartItem);
      for (var orderEntry in orderData.entries) {
        await userRefs[entry.key].collection('orders').add(orderEntry.value);
      }
    }
  });

  group('GET operations', () {
    test('Should return user document', () async {
      DocumentSnapshot data = await getUserDocument(userRefs['u1'].id, mockFsInstance: instance);
      expect(data, DocumentSnapshotMatcher(userRefs['u1'].id, userData['u1']));
    });

    test('Should return user cart', () async {
      QuerySnapshot data = await getUserCart(userRefs['u1'].id, mockFsInstance: instance);
      expect(data.docs.length, 1);
      expect(data, QuerySnapshotMatcher([
        DocumentSnapshotMatcher.onData(cartItem)
      ]));
    });

    test('Should return product document', () async {
      DocumentSnapshot data = await getProductDocument(prodRefs['p1'], mockFsInstance: instance);
      expect(data, DocumentSnapshotMatcher(prodRefs['p1'].id, prodData['p1']));
    });

    test('Should return orders still in progress of given user', () async {
      QuerySnapshot data = await getUserInProgressOrders(userRefs['u1'].id, mockFsInstance: instance);
      expect(data, QuerySnapshotMatcher([
        DocumentSnapshotMatcher.onData(orderData['o0'])
      ]));
    });

    test('Should return completed orders of given user', () async {
      QuerySnapshot data = await getUserCompletedOrders(userRefs['u1'].id, mockFsInstance: instance);

      expect(data, QuerySnapshotMatcher([
        DocumentSnapshotMatcher.onData(orderData['o1'])
      ]));
    });

    test('Should return hot deals products', () async {
      QuerySnapshot data = await getHotDeals(mockFsInstance: instance);

      var hotDeals = {...prodData}; // deep copy
      hotDeals.removeWhere((key, value) => !value['hot_deal']);
      List<DocumentSnapshotMatcher> expectedResults = [];
      hotDeals.forEach((key, value) => expectedResults.add(DocumentSnapshotMatcher.onData(value)));

      expect(data, QuerySnapshotMatcher(expectedResults));
    });

    test('Should return popular products', () async {
      QuerySnapshot data = await getPopulars(mockFsInstance: instance);

      var hotDeals = {...prodData}; // deep copy
      hotDeals.removeWhere((key, value) => !value['popular']);
      List<DocumentSnapshotMatcher> expectedResults = [];
      hotDeals.forEach((key, value) => expectedResults.add(DocumentSnapshotMatcher.onData(value)));

      expect(data, QuerySnapshotMatcher(expectedResults));
    });
  });


  group('Product search query', () {
    // Filters not specified are setup to default values, so they are implicitly tested
    test('Should provide the first cheapest products', () async {
      SearchFilters filters = SearchFilters(orderingKey: LocaleKeys.filter_cheapest_first);
      List<DocumentSnapshot> data = await getSearchQueryResult(filters, null,
          mockFsInstance: instance);

      List<DocumentSnapshotMatcher> expectedResults =
          priceOrderedProds.take(data.length)
              .map((e) => DocumentSnapshotMatcher.onData(e)).toList();

      expect(data, expectedResults);
    });
    test('Should provide products that match the string provided', () async {
      String query = 'int';
      SearchFilters filters = SearchFilters(queryText: query);
      List<DocumentSnapshot> data = await getSearchQueryResult(filters, null,
          mockFsInstance: instance);

      data.forEach((doc) {
        expect(satisfyQueryText(doc, query), true);
      });
    });
    test('Should provide products that match the price range', () async {
      SearchFilters filters = SearchFilters(priceRangeValues: RangeValues(200, 300));
      List<DocumentSnapshot> data = await getSearchQueryResult(filters, null,
          mockFsInstance: instance);

      data.forEach((doc) {
        expect(satisfyPriceRange(doc, 200, 300), true);
      });
    });
    test('Should provide products that satisfy at least one chosen category', () async {
      SearchFilters filters = SearchFilters(categoriesBool: {
        "Furniture": false,
        "Design": true,
        "Electronic": false,
        "Handmade": true,
        "Rustic": false,
        "Practical": false,
        "Unbranded": false,
        "Ergonomic": false,
        "Mechanical": false,
        "Wood": false,
        "Iron": false,
        "Plastic": false,
      });
      List<DocumentSnapshot> data = await getSearchQueryResult(filters, null,
          mockFsInstance: instance);

      data.forEach((doc) {
        expect(satisfyCategories(doc, ['Design', 'Handmade']), true);
      });
    });
    test('Should provide products that has an AR model associated', () async {
      SearchFilters filters = SearchFilters(showAROnly: true);
      List<DocumentSnapshot> data = await getSearchQueryResult(filters, null,
          mockFsInstance: instance);

      data.forEach((doc) {
        expect(doc.data()['has_AR'], true);
      });
    });
    test('Should provide products that satisfy all filters', () async {
      String query = 'ed';
      SearchFilters filters = SearchFilters(
          queryText: query,
          priceRangeValues: RangeValues(50, 250),
          showAROnly: true,
          categoriesBool: {
            "Furniture": false,
            "Design": false,
            "Electronic": true,
            "Handmade": false,
            "Rustic": false,
            "Practical": false,
            "Unbranded": false,
            "Ergonomic": false,
            "Mechanical": false,
            "Wood": false,
            "Iron": false,
            "Plastic": false,
          }
      );
      List<DocumentSnapshot> data = await getSearchQueryResult(filters, null,
          mockFsInstance: instance);

      data.forEach((doc) {
        expect(doc.data()['has_AR'] && satisfyPriceRange(doc, 50, 250)
            && satisfyQueryText(doc, query) && satisfyCategories(doc, ['Electronic']), true);
      });
    });
  });


  group('INSERT / UPDATE operations', () {
    test('Should delete db cart and update it with local data', () async {
      CartItem cItem1 = CartItem(prodRefs['p0'], 6);
      CartItem cItem2 = CartItem(prodRefs['p1'], 2);
      List<CartItem> localCart = [cItem1, cItem2];

      await updateUserCart(userRefs['u1'].id, localCart, mockFsInstance: instance);
      QuerySnapshot data = await getUserCart(userRefs['u1'].id, mockFsInstance: instance);

      List<DocumentSnapshotMatcher> expectedResults = localCart
          .map((e) => DocumentSnapshotMatcher.onData(e.asMap())).toList();
      expect(data, QuerySnapshotMatcher(expectedResults));
    });

    test('Should add order with local cart data as items', () async {
      CartItem cItem1 = CartItem(prodRefs['p0'], 6);
      CartItem cItem2 = CartItem(prodRefs['p1'], 2);
      List<CartItem> localCart = [cItem1, cItem2];

      DocumentSnapshot cItem1Doc = await getProductDocument(cItem1.productId,
          mockFsInstance: instance);
      DocumentSnapshot cItem2Doc = await getProductDocument(cItem2.productId,
          mockFsInstance: instance);
      Map<String, DocumentSnapshot> cartDocs = {};
      cartDocs.addAll({cItem1.productId.id: cItem1Doc});
      cartDocs.addAll({cItem2.productId.id: cItem2Doc});

      double totalPrice = cItem1Doc.data()['discounted_price']
          + cItem2Doc.data()['discounted_price'];

      String deliveryAddress = 'Via test 22, Milano, 1234';
      String paymentCard = '1234-5678, 12/12/2022';

      DocumentReference order = await addOrderFromCartData(userRefs['u1'].id,
          localCart, cartDocs, totalPrice, deliveryAddress,
          paymentCard, mockFsInstance: instance);

      QuerySnapshot orders = await getUserInProgressOrders(userRefs['u1'].id,
          mockFsInstance: instance);

      expect(orders.docs.length, 2);

      QuerySnapshot orderCartDocs = await order.collection('orderItems').get();
      expect(orderCartDocs.docs.length, localCart.length);
    });
  });
}
