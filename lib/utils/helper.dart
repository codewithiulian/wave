import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Helper {
  /// Returns a Material icon based on a collaboration type.
  static IconData getCollaborationIcon(String _collabType) {
    switch (_collabType) {
      case 'Errands':
        return MaterialCommunityIcons.run;
      case 'Cleaning':
        return MaterialCommunityIcons.silverware_clean;
      case 'Cooking':
        return MaterialCommunityIcons.chef_hat;
      case 'Babysitting':
        return MaterialCommunityIcons.human_child;
      case 'Handy Man':
        return MaterialCommunityIcons.hammer;
      case 'Furniture Fitting':
        return MaterialCommunityIcons.sofa;
      case 'Moving Out':
        return MaterialCommunityIcons.home;
      default:
        return Icons.work;
    }
  }

  /// Responsible for pushing a new page to the Navigator, thus navigating.
  /// Receives a context and a string route (see main.dart > routes).
  static void loadPage(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  /// Goes back to the page it has been loaded from.
  /// Receives a context
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Responsible for pushing a new page to the Navigator without the back btn.
  /// Receives a context and a string route (see main.dart > routes).
  static void redirect(BuildContext context, String route) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  /// Shows a SnackBar within a given Scaffold.
  /// Takes in a Key of ScaffoldState, a message string and a duration in seconds.
  static void showSnackBar(
      GlobalKey<ScaffoldState> scaffoldState, String message, int duration) {
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
