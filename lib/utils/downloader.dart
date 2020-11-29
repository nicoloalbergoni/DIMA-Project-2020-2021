import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

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

Future<String> downloadFromURL(String url) async {
  bool _permissionReady = await _checkPermission();
  //final savePath = p.join(await _localPath, 'myBundle');
  final pathToSave =
      (await _findLocalPath()) + Platform.pathSeparator + 'Download';

  final savedDir = Directory(pathToSave);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }

  final savePath = p.join(pathToSave, 'capsule');
  final taskId = await FlutterDownloader.enqueue(
    url: url,
    savedDir: pathToSave,
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification:
        false, // click on notification to open downloaded file (for Android)
  );

  return savePath;
}
