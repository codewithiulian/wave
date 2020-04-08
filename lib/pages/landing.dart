import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wave/models/userprofile.dart';
import 'package:wave/utils/database.dart';

import '../utils/auth.dart';
import '../utils/helper.dart';
import '../models/user.dart';
import 'tabs/components/waveeditor.dart';
import '../pages/tabs/home.dart';
import '../pages/tabs/waves.dart';
import '../pages/tabs/collabs.dart';
import '../pages/tabs/profile.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _authHelper = AuthHelper();
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldState =
  new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    final tabs = [
      HomeTab(),
      WavesTab(),
      CollabsTab(),
      ProfileTab(),
    ];

    void _showWaveEditor() {
      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          ),
          backgroundColor: Colors.grey[200],
          builder: (BuildContext context) {
            return Container(
                padding: EdgeInsets.all(30.0), child: WaveEditor());
          });
    }

    return StreamProvider<UserProfile>.value(
      value: DatabaseHelper(uid: user?.uid).profile,
      child: Scaffold(
          key: _scaffoldState,
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(
              'wave.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
            centerTitle: true,
          ),
          body: tabs[_currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showWaveEditor(),
            child: Icon(
              Icons.add,
              size: 40.0,
            ),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
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
          )),
    );
  }
}
