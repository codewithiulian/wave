import 'dart:core';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import 'login.dart';
import '../utils/helper.dart';
import 'feed.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  final String title = 'Sign up';

  @override
  State createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _errorMessage;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Image.asset('assets/images/wave.png', width: 100),
            Container(
              padding: EdgeInsets.all(40.0),
              child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          labelText: 'Email', prefixIcon: Icon(Icons.email)
                      ),
                      validator: (String value) {
                        return _validateEmail(value);
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                      validator: (String value) {
                        return _validatePassword(value);
                      },
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _register();
                          helper.redirect(context, FeedPage());
                        }
                      },
                      child: Text('Sign up'),
                    ),
                  ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please type in your email';
    }
    if (!EmailValidator.validate(value))
      return 'Please enter a valid email address';
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please choose a password';
    }
    if (value.length < 6) {
      return 'The password must be at least 6 characters long';
    }
    return null;
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    FirebaseUser user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text))
          .user;
    } catch (e) {
      if (e.toString().contains('ERROR_EMAIL_ALREADY_IN_USE'))
        setState(() {
          _success = false;
          _errorMessage = 'This email address is already in use.';
        });
    }
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}
