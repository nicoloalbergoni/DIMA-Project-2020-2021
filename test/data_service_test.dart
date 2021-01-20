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
  setUp(() async {
    prodData = await loadJsonData(p.join('data', 'products.json'));
    userData = await loadJsonData(p.join('data', 'users.json'));

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
    }
  });

  test("Should return user document", () async {
    final data = await getUserDocument(userRefs['u1'].id, mockFsInstance: instance);
    expect(data, DocumentSnapshotMatcher(userRefs['u1'].id, userData['u1']));
  });

  test("Should return user cart", () async {
    final data = await getUserCart(userRefs['u1'].id, mockFsInstance: instance);
    expect(data.docs.length, 1);
    expect(data, QuerySnapshotMatcher([
      DocumentSnapshotMatcher.onData(cartItem)
    ]));
  });
}
