import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/redux/appState.dart';
import 'package:realiteye/redux/reducers.dart';
import 'package:realiteye/ui/screens/product.dart';
import 'package:realiteye/ui/screens/unity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:redux/redux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );

  // Initialize Redux state
  final _initialState = AppState(cartItems: []);
  final Store<AppState> _store =
    Store<AppState>(appReducers, initialState: _initialState);

  runApp(MyApp(store: _store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => ProductScreen(),
          // TODO: modify this to get the correct bundlePath as extra
          '/unity': (context) => UnityScreen(bundlePath: "TODO"),
        },
      ),
    );
  }

}