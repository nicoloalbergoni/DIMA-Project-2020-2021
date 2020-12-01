import 'package:firebase_auth/firebase_auth.dart';

import '../models/cartItem.dart';

class AddItemAction {
  final CartItem item;

  AddItemAction(this.item);
}

class ChangeFirebaseUserAction {
  final User firebaseUser;

  ChangeFirebaseUserAction(this.firebaseUser);
}