import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'feed.dart';
import '../utils/helper.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  final String title = 'Sign up';

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState =
  new GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MultiValidator _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Please choose a password'),
    MinLengthValidator(8,
        errorText:
        'Please choose a password that is at least 8 characters long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText:
        'Please choose a password that is at least one special character')
  ]);
  final MultiValidator _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter your email address'),
    EmailValidator(errorText: 'Please enter a valid email address')
  ]);
  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

  bool _success;
  String _userEmail = '';
  String _registrationMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text(widget.title)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: RaisedButton.icon(
                    onPressed: _googleSignInOnPressed,
                    icon: Icon(
                      FontAwesome5Brands.google,
                      color: Colors.indigo,
                    ),
                    label: Text('Sign in with Google'),
                  ),
                ),
                alignment: Alignment.center,
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      Text('or sign up with your email'),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(FontAwesome.envelope),
                        ),
                        validator: _emailValidator,
//                        validator: (String value) => _validateEmail(value),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(FontAwesome.lock),
                        ),
                        validator: _passwordValidator,
                        obscureText: true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: RaisedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _emailSignUpOnPressed(context);
                            }
                          },
                          icon: Icon(
                            FontAwesome.check,
                            color: Colors.indigo,
                          ),
                          label: Text('Sign up'),
                        ),
                      ),
                    ],
                  ),
                ),
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _googleSignInOnPressed() {
    print('Google sign in pressed!');
  }

  void _emailSignUpOnPressed(BuildContext context) async {
    FirebaseUser user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text))
          .user;
    } catch (error) {
      setState(() {
        if (error.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
          _registrationMessage = 'The email address is already in registered';
        }
      });
    }

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        _registrationMessage = 'Successfuly registered on wave.';
      });

      helper.redirect(context, FeedPage());
    } else {
      _success = false;
      _showSnackBar();
    }
  }

  void _showSnackBar() {
    _scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(_registrationMessage),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () => _scaffoldState.currentState.hideCurrentSnackBar(),
        ),
      )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
