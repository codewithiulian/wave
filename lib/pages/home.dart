import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../utils/auth.dart';
import '../utils/helper.dart';
import '../pages/landing.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authHelper = AuthHelper();
  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Helper.verifyAuthentication(user, context);
    final tabs = [
      Center(child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(40.0),
              child: Text('Welcome ${user.displayName}')),
          RaisedButton(
            onPressed: () async => await _authHelper.signOut(),
            child: Text('Sign out'),
          ),
        ],
      ),),
      Center(child: Text('Waves'),),
      Center(child: Text('Collabs'),),
      Center(child: Text('Profile'),),
    ];
    // If the user is not logged in.
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.grey[200],
        appBar: null,
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 12.0,
          selectedFontSize: 12.0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              backgroundColor: Colors.blue[900],
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesome5.hand_paper),
              title: Text('Waves'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesome5.handshake),
              title: Text('Collabs'),
            ),
            BottomNavigationBarItem(
              icon: Icon(MaterialIcons.person),
              title: Text('Profile'),
            ),
          ],
        ));
  }
}
