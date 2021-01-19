import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter/services.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:test/test.dart';

const uid = 'abc';
MockFirestoreInstance instance;

void main() {

  setUp(() async {
    instance = MockFirestoreInstance();
    await instance.collection('users').doc(uid).set({
      'name': 'Bob',
    });
  });

  test("Get document ", () async {
    final data = await getUserDocument(uid);
    expect(data.data()['name'], 'Bob');
  });

  // group('MockFirestoreInstance.dump', () {
  //   const expectedDumpAfterset = '''{
  //                   "users": {
  //                     "abc": {
  //                       "name": "Bob"
  //                     }
  //                   }
  //                 }''';
  //
  //   test('Sets data for a document within a collection', () async {
  //     final instance = MockFirestoreInstance();
  //     await instance.collection('users').doc(uid).set({
  //       'name': 'Bob',
  //     });
  //     expect(instance.dump(), equals(expectedDumpAfterset));
  //   });
}
