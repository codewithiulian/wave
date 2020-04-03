import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(FeedPage());
}

class FeedPage extends StatefulWidget {
  FeedPage({this.title});

  final String title;

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    // If the user is not logged in.
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[200],
      appBar: null,
      body: Text('Welcome to the feed')
    );
  }
}
