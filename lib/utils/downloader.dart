import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

Future<String> _findLocalPath() async {
  final directory = await getExternalStorageDirectory();
  return directory.path;
}

Future<bool> _checkPermission() async {
  final status = await Permission.storage.status;
  if (status != PermissionStatus.granted) {
    final result = await Permission.storage.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  } else {
    return true;
  }
  return false;
}

Future<String> downloadUnityBundle(String bundlePath) async {
  //TODO: Check permissions
  bool _permissionReady = await _checkPermission();

  //TODO: Check status of the call
  String downloadURL = await storage.ref(bundlePath).getDownloadURL();

  final pathToSave =
      (await _findLocalPath()) + Platform.pathSeparator + 'Download';

  final savedDir = Directory(pathToSave);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }

  // basically remove "Assetbundles/" and take only the last part as name
  String bundleID = bundlePath.split('/').last;
  final savePath = p.join(pathToSave, bundleID);
  await FlutterDownloader.enqueue(
    fileName: bundleID,
    url: downloadURL,
    savedDir: pathToSave,
    showNotification: true, // TODO: Set to false in production
    openFileFromNotification: false
  );

  return savePath;
}
