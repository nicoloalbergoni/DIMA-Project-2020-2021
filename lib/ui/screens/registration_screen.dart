import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/utils/utils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegistrationWidget extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Registration page")),
        body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return Center(
              child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            decoration:
                            const InputDecoration(labelText: 'Email'),
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (!validateEmail(value))
                                return 'Not a valid email';
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                            const InputDecoration(labelText: 'Password'),
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
                            decoration: const InputDecoration(
                                labelText: 'Confirm Password'),
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
                                  User user = await _register(
                                      Scaffold.of(context));
                                  if (user != null) {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(
                                        ChangeFirebaseUserAction(user));
                                  }
                                }
                              },
                              child: Text("Submit"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          },
        ));
  }

  Future<User> _register(scaffold) async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      scaffold.showSnackBar(SnackBar(
        content: Text("${user.email} registered"),
      ));

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text("Failed to register with Email & Password"),
      ));

      return null;
    }
  }
}
