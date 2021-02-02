import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/generated/locale_keys.g.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/utils/data_service.dart';
import 'package:realiteye/utils/utils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.registration_title.tr())),
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (context) {
          return Center(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (!validateEmail(value)) return 'Not a valid email';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                          labelText: LocaleKeys.registration_name.tr()),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                          labelText: LocaleKeys.registration_surname.tr()),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                          labelText:
                              LocaleKeys.registration_confirm_password.tr()),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value != _passwordController.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.center,
                      child: RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            User user = await _register(context);
                            if (user != null) {
                              var store = StoreProvider.of<AppState>(context);
                              store.dispatch(ChangeFirebaseUserAction(user));
                              store.dispatch(FetchCartAction());
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(LocaleKeys.registration_button.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<User> _register(BuildContext context) async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      Map<String, dynamic> _userData = {
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'email': user.email,
      };

      addUser(user, _userData);

      // TODO: because of Navigator.pop it will not be visible in time
      displaySnackbarWithText(context, "${user.email} registered");

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print(e.code + ': The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print(e.code + ': The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      displaySnackbarWithText(
          context, LocaleKeys.snackbar_registration_failed.tr());
      return null;
    }
  }
}
