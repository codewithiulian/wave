import 'package:flutter/material.dart';
import '../models/user.dart';
import '../pages/landing.dart';

class Helper {
  /// Responsible for pushing a new page to the Navigator, thus navigating.
  /// Receives a context and a widget page.
  static void loadPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  /// Verifies the user is authenticated.
  /// If not, the app redirects to the landing page.
  static void verifyAuthentication(User user, BuildContext context) {
    if(user == null) redirect(context, LandingPage());
  }

  /// Goes back to the page it has been loaded from.
  /// Receives a context
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Responsible for pushing a new page to the Navigator.
  /// Receives a context and a widget page.
  static void redirect(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => page),
        (Route<dynamic> route) => false);
  }

  /// Shows a SnackBar within a given Scaffold.
  /// Takes in a Key of ScaffoldState, a message string and a duration in seconds.
  static void showSnackBar(GlobalKey<ScaffoldState> scaffoldState,
      String message, int duration) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () => scaffoldState.currentState.hideCurrentSnackBar(),
      ),
    ));
  }
}
