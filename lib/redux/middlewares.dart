import 'package:realiteye/models/cartItem.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:redux/redux.dart';

import 'app_state.dart';

// A middleware takes in 3 parameters: your Store, which you can use to
// read state or dispatch new actions, the action that was dispatched,
// and a `next` function. The first two you know about, and the `next`
// function is responsible for sending the action to your Reducer, or
// the next Middleware if you provide more than one.
//
// Middleware do not return any values themselves. They simply forward
// actions on to the Reducer or swallow actions in some special cases.


void fetchCartMiddleware(Store<AppState> store, action, NextDispatcher next) {
  if (action is FetchCartAction) {
    getUserCart(store.state.firebaseUser.uid)
        .then((snapshot) {
          List<CartItem> cartItems = [];
          for (var doc in snapshot.docs) {
            print(doc.data().toString());
            cartItems.add(CartItem(doc.data()['product'], doc.data()['quantity']));
          }

          store.dispatch(new FetchCartSucceededAction(cartItems));
        })
        .catchError((Object error) {
          store.dispatch(new FetchCartFailedAction(error));
        });
  }

  // Make sure our actions continue on to the reducer.
  next(action);
}