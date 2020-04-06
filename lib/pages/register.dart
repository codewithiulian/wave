import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:wave/models/user.dart';
import 'landing.dart';
import '../utils/helper.dart';
import '../utils/auth.dart';

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
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  String _password = '';
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
  final AuthHelper _authHelper = AuthHelper();

  String _registrationMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Form(
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
                      onPressed: () async {
                        await _googleSignInOnPressed();
                      },
                      icon: Icon(
                        FontAwesome5Brands.google,
                        color: Colors.indigo,
                      ),
                      label: Text('Sign up with Google'),
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
                          onChanged: (val) => _password = val,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(FontAwesome.lock),
                          ),
                          validator: _passwordValidator,
                          obscureText: true,
                        ),
                        TextFormField(
                          controller: _passwordConfirmController,
                          decoration: const InputDecoration(
                            labelText: 'Confirm password',
                            prefixIcon: Icon(FontAwesome.lock),
                          ),
                          validator: (confirmedPassword) => MatchValidator(
                                  errorText: 'Passwords do not match')
                              .validateMatch(_password, confirmedPassword),
                          obscureText: true,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: RaisedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await _emailSignUpOnPressed(context);
                              }
                            },
                            icon: Icon(
                              FontAwesome.check,
                              color: Colors.indigo,
                            ),
                            label: Text('Create account'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: Text('Already have an account?'),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                          child: FlatButton(
                            child: Text('Log in'),
                            textColor: Colors.indigo,
                            onPressed: () => Helper.goBack(context),
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
        _registrationMessage =
            'An erorr occured while attempting to sign in with your Google account.';
      });
    }

    if (user != null) {
      setState(() {
        _registrationMessage = 'Successfuly signed in on wave.';
        print('Successfuly signed in. Redirecting to the Home page.');
      });

      // Redirect to the Feed
      Helper.redirect(context, '/HomePage');
    } else {
      Helper.showSnackBar(_scaffoldState, _registrationMessage, 5);
    }
  }

  Future<void> _emailSignUpOnPressed(BuildContext context) async {
    User user;
    try {
      user = await _authHelper.registerUserWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    } catch (error) {
      setState(() {
        if (error.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
          _registrationMessage = 'The email address is already in registered';
        }
      });
    }

    if (user != null) {
      setState(() {
        _registrationMessage = 'Successfuly registered on wave.';
      });

      // Redirect to the Feed
      Helper.redirect(context, '/HomePage');
    } else {
      Helper.showSnackBar(_scaffoldState, _registrationMessage, 5);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
