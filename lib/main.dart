import 'package:dima_test/unity.dart';
import 'package:flutter/material.dart';
import 'downloader.dart';

void main() {
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
              String path = await downloadFromURL('http://localhost:8080/capsule');
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UnityScreen(bundlePath: path,)));
            },
          ),
        )
      );
  }

}