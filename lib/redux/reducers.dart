import 'package:realiteye/models/cart_item.dart';
import 'package:realiteye/redux/app_state.dart';

import 'actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is AddCartItemAction) {
    return addCartItem(state, action);
  }
  else if (action is RemoveCartItemAction) {
    return removeCartItem(state, action);
  }
  else if (action is ClearCartItemList) {
   return  clearCartItemList(state, action);
  }
  else if (action is ChangeCartItemQuantity) {
    return changeCartItemQuantity(state, action);
  }
  else if (action is ChangeFirebaseUserAction) {
    return changeFirebaseUser(state, action);
  }
  else if (action is SwitchThemeAction) {
    return switchTheme(state, action);
  }
  else if (action is AddHistoryItemAction) {
    return addHistoryItem(state, action);
  }
  else if (action is FetchCartAction) {
    return onCartFetchStart(state, action);
  }
  else if (action is FetchCartSucceededAction) {
    return fetchCartSucceeded(state, action);
  }
  else if (action is FetchCartFailedAction) {
    return fetchCartFailed(state, action);
  }
  else if (action is FirebaseLogoutAction) {
    return firebaseLogout(state, action);
  }
  else {
    print('Invalid redux action, check reducer');
  }

  return state;
}

AppState addCartItem(AppState state, AddCartItemAction action) {
  return state.copyWith(cartItems: <CartItem>[]
    ..addAll(state.cartItems)
    ..add(action.item)
  );
}

AppState removeCartItem(AppState state, RemoveCartItemAction action) {
  return state.copyWith(cartItems: <CartItem>[]
    ..addAll(state.cartItems)
    ..removeWhere((item) => item.productId == action.productId)
  );
}

AppState clearCartItemList(AppState state, ClearCartItemList action) {
  return state.copyWith(cartItems: <CartItem>[]);
}

AppState changeCartItemQuantity(AppState state, ChangeCartItemQuantity action) {
  return state.copyWith(cartItems: <CartItem>[]
    ..addAll(state.cartItems.map((e) => (e.productId == action.item.productId)
        ? action.item : e
    )));
}

AppState changeFirebaseUser(AppState state, ChangeFirebaseUserAction action) {
  return state.copyWith(firebaseUser: action.firebaseUser);
}

AppState switchTheme(AppState state, SwitchThemeAction action) {
  return state.copyWith(theme: action.theme);
}

AppState addHistoryItem(AppState state, AddHistoryItemAction action) {
  return state.copyWith(searchHistory: <String>[]
    ..add(action.searchedString)
    ..addAll(state.searchHistory.take(5)));
}

AppState onCartFetchStart(AppState state, FetchCartAction action) {
  return state.copyWith(isFetching: true, error: null);
}

AppState fetchCartSucceeded(AppState state, FetchCartSucceededAction action) {
  return state.copyWith(cartItems: action.fetchedCartItems, isFetching: false);
}

AppState fetchCartFailed(AppState state, FetchCartFailedAction action) {
  return state.copyWith(error: action.error, isFetching: false);
}

AppState firebaseLogout(AppState state, FirebaseLogoutAction action) {
  // copyWith doesn't support null values
  return new AppState(
      firebaseUser: null,
      cartItems: [],
      theme: state.theme,
      searchHistory: state.searchHistory,
      isFetching: state.isFetching,
      error: state.error
  );
}