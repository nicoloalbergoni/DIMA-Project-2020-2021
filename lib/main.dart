import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/redux/middlewares.dart';
import 'package:realiteye/redux/reducers.dart';
import 'package:realiteye/ui/screens/cart_screen.dart';
import 'package:realiteye/ui/screens/home_screen.dart';
import 'package:realiteye/ui/screens/login_screen.dart';
import 'package:realiteye/ui/screens/order_screen.dart';
import 'package:realiteye/ui/screens/product_screen.dart';
import 'package:realiteye/ui/screens/profile_screen.dart';
import 'package:realiteye/ui/screens/registration_screen.dart';
import 'package:realiteye/ui/screens/search_screen.dart';
import 'package:realiteye/ui/screens/unity_screen.dart';
import 'package:realiteye/ui/widgets/lifecycle_watcher.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

import 'generated/locale_keys.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  // Initialize Redux state
  final _initialState = AppState(
      cartItems: [],
      firebaseUser: null,
      theme: ThemeMode.light,
      searchHistory: ['item 1']);
  final Store<AppState> _store = Store<AppState>(appReducers,
      initialState: _initialState,
      middleware: [fetchCartMiddleware, new LoggingMiddleware.printer()]);

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
            EasyLocalization(
              supportedLocales: [Locale('en', 'US'), Locale('it', 'IT')],
              path: 'assets/translations',
              fallbackLocale: Locale('en', 'US'),
              saveLocale: true,
              child: MyApp(store: _store),
            ),
          ));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final Color teal = Colors.teal[700];
  final Color tealAccent = Colors.tealAccent[400];

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text(LocaleKeys.error.tr(), textDirection: TextDirection.ltr);
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // insert user in state if already present
          // TODO: login expires automatically?
          if (FirebaseAuth.instance.currentUser != null) {
            store.dispatch(
                ChangeFirebaseUserAction(FirebaseAuth.instance.currentUser));
            store.dispatch(FetchCartAction());
          }

          return StoreProvider<AppState>(
            store: store,
            child: StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, state) {
                /* This gesture handler allows to unfocus any focused widget
                  in any screen of the app when user taps outside a focusable widget,
                  giving the application a better user experience.
                  See: https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
                   */
                return GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      currentFocus.focusedChild.unfocus();
                    }
                  },
                  child: LifecycleWatcher(
                    child: MaterialApp(
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: context.locale,
                      theme: ThemeData(
                        brightness: Brightness.light,
                        colorScheme:
                            ColorScheme.fromSwatch(primarySwatch: Colors.teal),
                        primaryColor: teal,
                        accentColor: tealAccent,
                        toggleableActiveColor: teal,
                        buttonTheme: ButtonThemeData(
                          buttonColor: teal,
                          textTheme: ButtonTextTheme.primary,
                        ),
                      ),
                      darkTheme: ThemeData(
                        brightness: Brightness.dark,
                        floatingActionButtonTheme:
                            FloatingActionButtonThemeData(
                          backgroundColor: tealAccent,
                        ),
                        sliderTheme: SliderThemeData(
                          activeTrackColor: tealAccent,
                          inactiveTrackColor: tealAccent.withOpacity(.3),
                          thumbColor: tealAccent,
                          overlayColor: tealAccent.withOpacity(.1),
                        ),
                        buttonTheme: ButtonThemeData(
                            buttonColor: tealAccent,
                            textTheme: ButtonTextTheme.primary
                        ),
                      ),
                      themeMode: state.theme,
                      /* ThemeMode.system to follow system theme,
                      ThemeMode.light for light theme,
                      ThemeMode.dark for dark theme
                      */
                      initialRoute: '/',
                      routes: {
                        '/': (context) => HomeScreen(),
                        '/product': (context) => ProductScreen(),
                        '/login': (context) => LoginScreen(),
                        '/register': (context) => RegistrationScreen(),
                        '/unity': (context) => UnityScreen(),
                        '/cart': (context) => CartScreen(),
                        '/search': (context) => SearchScreen(),
                        '/profile': (context) => ProfileScreen(),
                        '/orders': (context) => OrderScreen()
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Text(LocaleKeys.loading.tr(), textDirection: TextDirection.ltr);
      },
    );
  }
}
