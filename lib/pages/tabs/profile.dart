import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/models/user.dart';
import 'package:wave/models/userprofile.dart';
import 'package:wave/utils/database.dart';

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
    final UserProfile profile = Provider.of<UserProfile>(context);
    final User user = Provider.of<User>(context);
    final DatabaseHelper database = DatabaseHelper(uid: user?.uid);

    if (profile != null) {
      bool switchToLancerVal = profile.accountType == 'Lancer';
      String switchTextValue = _getSwitchTextValue(profile.accountType);

      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Switch $switchTextValue',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Switch(
                    value: switchToLancerVal,
                    onChanged: (val) async {
                      setState(() => switchToLancerVal = val);
                      await database.switchUserAccountType(
                          user.uid, _getAccountType(val));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Sign out wave.',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      await _authHelper.signOut();
                      Helper.redirect(context, '/LoginPage');
                    },
                    child: Text(
                      'Sign out',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  String _getAccountType(bool isLancer) {
    if (isLancer) return 'Lancer';
    return 'Waver';
  }

  String _getSwitchTextValue(String accountType) {
    if (accountType == 'Waver') return 'to Lancer';
    return 'back to Waver';
  }
}
