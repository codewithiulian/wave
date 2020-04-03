import 'dart:core';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import 'login.dart';
import '../utils/helper.dart';


class FeedPage extends StatefulWidget {
  final String title = 'Feed';

  @override
  State createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Text('Welcome to the feed')
    );
  }
}
