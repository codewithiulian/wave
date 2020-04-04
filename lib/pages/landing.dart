import 'package:flutter/material.dart';

import '../utils/helper.dart';
import '../pages/register.dart';
import '../pages/login.dart';

class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 250, 0.0, 0.0),
            child: Text(
              'wave.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900),
            ),
            alignment: Alignment.center,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 70, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: RaisedButton(
                    child: Text('Sign up'),
                    onPressed: () => Helper.loadPage(context, RegisterPage()),
                  ),
                ),
                Text('or'),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    child: Text('Log in'),
                    onPressed: () => Helper.loadPage(context, LoginPage()),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
