import 'package:flutter/material.dart';

import 'package:wave/utils/helper.dart';
import 'package:wave/utils/auth.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _authHelper = AuthHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () async {
          await _authHelper.signOut();
          Helper.redirect(context, '/LoginPage');
        },
        child: Text('Sign out'),
      ),
    );
  }
}

