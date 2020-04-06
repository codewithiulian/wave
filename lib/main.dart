import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'pages/landing.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'utils/router.dart';
import 'utils/auth.dart';

void main() => runApp(Wave());

class Wave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthHelper().user,
      child: MaterialApp(
        title: 'wave',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Router(),
        routes: <String, WidgetBuilder>{
          "/LoginPage": (BuildContext context) => new LoginPage(),
          "/RegisterPage": (BuildContext context) => new RegisterPage(),
          "/HomePage": (BuildContext context) => new LandingPage(),
        },
      ),
    );
  }
}
