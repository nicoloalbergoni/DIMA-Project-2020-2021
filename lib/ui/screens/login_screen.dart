import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:realiteye/redux/actions.dart';
import 'package:realiteye/redux/app_state.dart';
import 'package:realiteye/utils/data_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login page")),
        body: Builder(
          builder: (context) {
            return Center(
              child: Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (String value) {
                            if (value.isEmpty) return 'Please enter some text';
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                          const InputDecoration(labelText: 'Password'),
                          validator: (String value) {
                            if (value.isEmpty) return 'Please enter some text';
                            return null;
                          },
                          obscureText: true,
                        ),
                        RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                User user = await _signInWithEmailAndPassword(
                                    Scaffold.of(context));
                                if (user != null) {
                                  StoreProvider.of<AppState>(context)
                                      .dispatch(ChangeFirebaseUserAction(user));
                                }
                              }
                            },
                            child: Text("Sign In")),
                        RaisedButton(
                            onPressed: () async {
                              User user =
                              await _signInWithGoogle(Scaffold.of(context));
                              if (user != null) {
                                StoreProvider.of<AppState>(context)
                                    .dispatch(ChangeFirebaseUserAction(user));
                              }
                            },
                            child: Text("Sign In with Google"))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        )
    );
  }

  Future<User> _signInWithEmailAndPassword(scaffold) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      scaffold.showSnackBar(SnackBar(
        content: Text("${user.email} signed in"),
      ));

      return user;
    } catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text("Failed to sign in with Email & Password"),
      ));

      return null;
    }
  }

  Future<User> _signInWithGoogle(scaffold) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      List<String> displayNameSplit = user.displayName.split(" ");

      Map<String, dynamic> userData = {
        'firstname': displayNameSplit[0],
        'lastname': displayNameSplit[1],
        'email': user.email,
        'photoURL': user.photoURL
      };

      addUser(user, userData);

      scaffold.showSnackBar(SnackBar(
        content: Text("${user.displayName} Logged in"),
      ));

      return user;
    } on FirebaseAuthException catch (e) {
      print("Error code: ${e.code}");
      scaffold.showSnackBar(SnackBar(
        content: Text("Error during authentication"),
      ));
      return null;
    } catch (e) {
      print(e);
      scaffold.showSnackBar(SnackBar(
        content: Text("Error"),
      ));
      return null;
    }
  }
}
