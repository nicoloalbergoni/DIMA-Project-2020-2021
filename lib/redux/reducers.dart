import 'package:realiteye/redux/appState.dart';

import 'actions.dart';
import '../models/cartItem.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is AddItemAction) {
    return addItem(state.cartItems, action);
  }
  else if (action is ToggleItemStateAction) {
    return toggleItemState(state.cartItems, action);
  }

  return state;
}

AppState addItem(List<CartItem> items, AddItemAction action) {
  return AppState(
      cartItems: List.from(items)..add(action.item)
  );
}

AppState toggleItemState(List<CartItem> items, ToggleItemStateAction action) {
  return AppState(
    cartItems: items.map((item) => item.name == action.item.name ?
      action.item : item).toList()
  ); // AppState
}