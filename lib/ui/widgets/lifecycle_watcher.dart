import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/utils/data_service.dart';

/// Fictitious widget, that is supposed to wrap the main application.
/// It listens to the life cycle changes of the application, so that is possible
/// to perform operations when the app is stopped, closed or resumed.
class LifecycleWatcher extends StatefulWidget {
  final Widget child;

  LifecycleWatcher({@required this.child});

  @override
  _LifecycleWatcherState createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastLifecycleState == null) {
      print('[LC watcher] Not observed any lifecycle changes.');
      return widget.child;
    }
    else {
      print('[LC watcher] The most recent lifecycle state observed was: $_lastLifecycleState.');
      // Called if the app is closed or paused (background)
      if(_lastLifecycleState == AppLifecycleState.inactive) {
        var state = StoreProvider.of<AppState>(context).state;
        if (state.firebaseUser != null) {
          updateUserCart(state.firebaseUser.uid, state.cartItems);
        }
      }
      return widget.child;
    }
  }
}