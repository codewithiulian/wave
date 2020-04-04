import 'package:flutter/material.dart';

class Helper {
  /// Responsible for pushing a new page to the Navigator, thus navigating.
  /// Receives a context and a widget page.
  static void loadPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  /// Responsible for pushing a new page to the Navigator.
  /// Receives a context and a widget page.
  static void redirect(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => page),
            (Route<dynamic> route) => false
    );
  }
}