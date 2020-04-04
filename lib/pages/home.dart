import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/auth.dart';
import '../utils/helper.dart';
import '../pages/landing.dart';


class HomePage extends StatelessWidget {
  final AuthHelper _authService = AuthHelper();

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
            onPressed: () async {
              await _authService.signOut();
              Helper.redirect(context, LandingPage());
            },
            child: Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
