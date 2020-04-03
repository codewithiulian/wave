import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String title = 'Log in';
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title)
      ),
    );
  }

}