import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/auth.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  HomePage({this.title});

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    // If the user is not logged in.
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[200],
      appBar: null,
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(40.0), child: Text('Welcome to the feed')),
          RaisedButton(
            onPressed: () async => await _authService.signOut(),
            child: Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
