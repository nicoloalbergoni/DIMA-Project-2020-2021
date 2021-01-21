import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:path/path.dart' as p;
import 'package:realiteye/utils/data_service.dart';
import 'package:test/test.dart';

import 'utils/document_snapshot_matcher.dart';
import 'utils/query_snapshot_matcher.dart';

const uid = 'abc';
MockFirestoreInstance instance;
Map<String, dynamic> prodData;
Map<String, dynamic> userData;
Map<String, dynamic> orderData;

Map<String, DocumentReference> prodRefs = {};
Map<String, DocumentReference> userRefs = {};

Map<String, dynamic> cartItem = {
  'product_id': prodRefs['p0'],
  'quantity': 4
};

Future<Map<String, dynamic>> loadJsonData(String path) {
  return new File(path)
      .readAsString()
      .then((fileContents) => jsonDecode(fileContents));
}

void main() {
  // Executed before each test, reset the mock to a predefined db instance,
  // avoiding test side-effects from influencing the successive ones.
  setUp(() async {
    prodData = await loadJsonData(p.join('data', 'products.json'));
    userData = await loadJsonData(p.join('data', 'users.json'));
    // only two orders now: o0 in progress, o1 completed
    orderData = await loadJsonData(p.join('data', 'orders.json'));

    instance = MockFirestoreInstance();
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
    // TODO: multiple filters configuration tests
  });

  group('INSERT / UPDATE operations', () {
    // TODO
  });
}
