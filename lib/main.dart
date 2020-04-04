import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/router.dart';
import 'models/user.dart';
import 'pages/landing.dart';
import 'utils/auth.dart';

void main() {
  runApp(Wave());
}

class Wave extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: _authService.user,
      child: MaterialApp(
        title: 'wave',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Router(),
      ),
    );
  }
}
