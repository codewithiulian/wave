import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../utils/helper.dart';
import '../utils/auth.dart';
import '../pages/register.dart';
import '../pages/home.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final MultiValidator _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Please enter your email address'),
    EmailValidator(errorText: 'Please enter a valid email address')
  ]);
  final AuthHelper _authHelper = AuthHelper();
  String _loginMessage;

  @override
  Widget build(BuildContext context) {
    // If the user is not logged in.
    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.grey[200],
      appBar: null,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 150, 0.0, 0.0),
                child: Text(
                  'wave.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900),
                ),
                alignment: Alignment.center,
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: RaisedButton.icon(
                    onPressed: () async {
                      await _googleSignInOnPressed();
                    },
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
                      Text('or with your email'),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(FontAwesome.envelope),
                        ),
                        validator: _emailValidator,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(FontAwesome.lock),
                        ),
                        validator: RequiredValidator(
                            errorText: 'Please enter your password.'),
                        obscureText: true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: RaisedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await _emailLogInOnPressed(context);
                            }
                          },
                          icon: Icon(
                            FontAwesome.check,
                            color: Colors.indigo,
                          ),
                          label: Text('Log in'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: Text("Don't have an account yet?"),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                        child: FlatButton(
                          child: Text('Sign Up'),
                          textColor: Colors.indigo,
                          onPressed: () => Helper.loadPage(context, RegisterPage()),
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

  Future _googleSignInOnPressed() async {
    User user;
    try {
      print('Signing user in with Google...');
      user = await _authHelper.signUserInWithGoogle();
    } catch (e) {
      setState(() {
        _loginMessage =
        'An erorr occured while attempting to sign in with your Google account.';
      });
    }

    if (user != null) {
      setState(() {
        _loginMessage = 'Successfuly signed in on wave.';
      });

      // Redirect to the Feed
      Helper.redirect(context, HomePage());
    } else {
      Helper.showSnackBar(_scaffoldState, _loginMessage, 5);
    }
  }

  Future<void> _emailLogInOnPressed(BuildContext context) async {
    User user;
    try {
      user = await _authHelper.authenticateUserWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    } catch (error) {
      setState(
          () => _loginMessage = 'An error occured while attempting to log in.');

      // Error handling based on the error caught.
      if (error.toString().contains('ERROR_USER_NOT_FOUND') ||
          error.toString().contains('ERROR_WRONG_PASSWORD')) {
        setState(() => _loginMessage = 'Incorrect email or password');
      } else if(error.toString().contains('ERROR_INVALID_EMAIL')) {
        setState(() => _loginMessage = 'Invalid email or password');
      }
    }

    if (user != null) {
      setState(() {
        _loginMessage = 'Successfuly signed in on wave.';
      });

      // Redirect to the Feed
      Helper.redirect(context, HomePage());
    } else {
      Helper.showSnackBar(_scaffoldState, _loginMessage, 5);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
