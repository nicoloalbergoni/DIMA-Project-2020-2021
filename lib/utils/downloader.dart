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

  final pathToSave =
      (await _findLocalPath()) + Platform.pathSeparator + 'Download';

  final savedDir = Directory(pathToSave);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }

  // basically remove "Assetbundles/" and take only the last part as name
  String bundleID = bundlePath.split('/').last;
  String savePath = p.join(pathToSave, bundleID);

  if (isFileCached(savePath)) {
    print('AssetBundle already cached locally');
  }
  else {
    try {
      String downloadURL = await storage.ref(bundlePath).getDownloadURL();

      await FlutterDownloader.enqueue(
          fileName: bundleID,
          url: downloadURL,
          savedDir: pathToSave,
          showNotification: true, // TODO: Set to false in production
          openFileFromNotification: false
      );
    }
    catch(e) {
      print('Error while downloading assetBundle');
      savePath = null;
    }
  }

  return savePath;
}

/// Check that file exists and that it's less than 1 day old
bool isFileCached(String savePath) {
  File f = File(savePath);

  return f.existsSync() &&
      DateTime.now().compareTo(f.lastModifiedSync().add(Duration(days: 1))) <= 0;
}
