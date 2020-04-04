import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home.dart';
import '../pages/landing.dart';
import '../models/user.dart';

class Router extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Add listener to the User provider defined in Wave class.
    final user = Provider.of<User>(context);

    // Return to the LandingPage if not authenticated.
    return user != null ? HomePage() : LandingPage();
  }
}