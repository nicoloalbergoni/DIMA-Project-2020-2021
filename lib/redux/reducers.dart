import 'package:realiteye/redux/app_state.dart';

import 'actions.dart';
import '../models/cartItem.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is AddItemAction) {
    return addItem(state, action);
  }
  else if (action is ChangeFirebaseUserAction) {
    return changeFirebaseUser(state, action);
  }
  else if (action is SwitchThemeAction) {
    return switchTheme(state, action);
  }

  return state;
}

AppState addItem(AppState state, AddItemAction action) {
  return state.copyWith(cartItems: <CartItem>[]
    ..addAll(state.cartItems)
    ..add(action.item)
  );
}

AppState changeFirebaseUser(AppState state, ChangeFirebaseUserAction action) {
  return state.copyWith(firebaseUser: action.firebaseUser);
}

AppState switchTheme(AppState state, SwitchThemeAction action) {
  return state.copyWith(theme: action.theme);
}