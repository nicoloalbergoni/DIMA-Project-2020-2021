import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginWidget extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product info'),
        ),
        body: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
              return Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      //initialValue: "pippo@paperino.com",
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter some text';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      //initialValue: "12345",
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (String value) {
                        if (value.isEmpty) return 'Please enter some text';
                        return null;
                      },
                      obscureText: true,
                    ),
                    FlatButton(onPressed: () async {
                      var user = await _signInWithEmailAndPassword(Scaffold.of(context));
                      if(user != null) {
                        StoreProvider.of<AppState>(context)
                            .dispatch(ChangeFirebaseUserAction(user));
                      }
                    },
                        child: Text("Sign In"))
                  ],
                ),
              );
          }
        )
    );
  }

  // Example code of how to sign in with email and password.
  Future<User> _signInWithEmailAndPassword(scaffold) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )).user;

      scaffold.showSnackBar(SnackBar(
        content: Text("${user.email} signed in"),
      ));

      return user;
    }
    catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text("Failed to sign in with Email & Password"),
      ));

      return null;
    }
  }

}

