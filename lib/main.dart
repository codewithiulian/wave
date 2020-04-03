import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wave/pages/register.dart';
import 'utils/helper.dart';

void main() {
  runApp(Wave());
}

class Wave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wave',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(title: 'Home'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({this.title});

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    // If the user is not logged in.
    return Scaffold(
        body: RegisterPage()
    );
  }
}
