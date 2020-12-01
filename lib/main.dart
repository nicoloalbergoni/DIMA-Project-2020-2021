import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/redux/reducers.dart';
import 'package:realiteye/ui/screens/login_screen.dart';
import 'package:realiteye/ui/screens/product.dart';
import 'package:realiteye/ui/screens/registration_screen.dart';
import 'package:realiteye/ui/screens/unity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:redux/redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:redux_logging/redux_logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  // Initialize Redux state
  final _initialState = AppState(cartItems: [], firebaseUser: null);
  final Store<AppState> _store = Store<AppState>(appReducers,
      initialState: _initialState,
      middleware: [new LoggingMiddleware.printer()]);

  runApp(MyApp(store: _store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Something went wrong", textDirection: TextDirection.ltr);
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // insert user in state if already present
          // TODO: login expires automatically?
          if (FirebaseAuth.instance.currentUser != null) {
            store.dispatch(
                ChangeFirebaseUserAction(FirebaseAuth.instance.currentUser));
          }

          return StoreProvider<AppState>(
            store: store,
            child: MaterialApp(
              initialRoute: '/',
              routes: {
                '/': (context) => ProductScreen(),
                '/login': (context) => LoginWidget(),
                '/register': (context) => RegistrationWidget(),
                // TODO: modify this to get the correct bundlePath as extra
                '/unity': (context) => UnityScreen(bundlePath: "TODO"),
              },
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Text(
          "Loading...",
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}
