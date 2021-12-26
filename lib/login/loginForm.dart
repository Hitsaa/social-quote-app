import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quoteapp/dashboard/ProfilePage.dart';

import 'package:quoteapp/signup/signUp.dart';
import 'package:quoteapp/utils/fire_auth.dart';
import 'package:quoteapp/utils/validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  bool _success = true;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: FutureBuilder(
              future: _initializeFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'Login',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailTextController,
                                focusNode: _focusEmail,
                                validator: (value) => Validator.validateEmail(
                                  email: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              TextFormField(
                                controller: _passwordTextController,
                                focusNode: _focusPassword,
                                obscureText: true,
                                validator: (value) =>
                                    Validator.validatePassword(
                                  password: value,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.0),
                              _isProcessing
                                  ? CircularProgressIndicator()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              _focusEmail.unfocus();
                                              _focusPassword.unfocus();

                                              setState(() {
                                                _success = true;
                                              });
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isProcessing = true;
                                                });

                                                User? user = await FireAuth
                                                    .signInUsingEmailPassword(
                                                  email:
                                                      _emailTextController.text,
                                                  password:
                                                      _passwordTextController
                                                          .text,
                                                );

                                                setState(() {
                                                  _isProcessing = false;
                                                });

                                                if (user != null) {
                                                  setState(() {
                                                    _success = true;
                                                  });
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                              user: user),
                                                    ),
                                                  );
                                                } else {
                                                  setState(() {
                                                    _success = false;
                                                  });
                                                }
                                              }
                                            },
                                            child: Text(
                                              'Sign In',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 24.0),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignupScreen(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Register',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  _success ? '' : 'Sign in Failed',
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )),
    );
  }
}
