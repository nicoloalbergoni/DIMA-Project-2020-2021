import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<String> downloadFromURL (String url) async {
  // TODO: place initialization in a proper place to not re-execute it every time
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );

  final savePath = p.join(await _localPath, 'myBundle');
  final taskId = await FlutterDownloader.enqueue(
    url: url,
    savedDir: await _localPath,
    showNotification: true, // show download progress in status bar (for Android)
    openFileFromNotification: false, // click on notification to open downloaded file (for Android)
  );

  return savePath;
}