import 'package:dima_test/unity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );

  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Product info'),
        ),
        body: Center(
          child: FlatButton(
            child: Text('Open Unity'),
            onPressed: () async {
              String path = await downloadFromURL('http://192.168.1.5:8000/capsule');
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UnityScreen(bundlePath: path,)));
            },
          ),
        )
      );
  }

}