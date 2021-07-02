import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:flutter_todo_online/models/constants.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  AuthMode _authMode = AuthMode.signIn;
  late String _name;
  late String _email;
  late String _password;
  late String _username;
  final _passwordController = TextEditingController();
  bool _loggingIn = false;
  String? _message;
  void _switchAuthMode() {
    _passwordController.clear();
    _formKey.currentState!.reset();
    setState(() {
      if (_authMode == AuthMode.signIn) {
        _authMode = AuthMode.signUp;
      } else {
        _authMode = AuthMode.signIn;
      }
      _message = null;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _loggingIn = true;
      _message = null;
    });
    try {
      if (_authMode == AuthMode.signUp) {
        await Provider.of<Api>(context, listen: false)
            .signUp(
          name: _name,
          email: _email,
          username: _username,
          password: _password,
        )
            .then((message) {
          setState(() {
            _loggingIn = false;
            _message = message;
          });
        });
      } else {
        await Provider.of<Api>(context, listen: false)
            .signIn(_username, _password)
            .then((message) {
          setState(() {
            _loggingIn = false;
            _message = message;
          });
        });
      }
    } on Exception catch (e) {
      setState(() {
        _message = ErrorMessages.getErrorMessage(e);
        _loggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: min(_authMode == AuthMode.signIn ? 320 : 460,
          mediaQuery.size.height * 0.60),
      padding: EdgeInsets.all(15),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    _message ?? '',
                    style: TextStyle(color: Colors.red),
                  ),
                  if (_authMode == AuthMode.signUp)
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (name) {
                        if (name != null &&
                            (name.trim()).isNotEmpty &&
                            name.trim().length < 140) {
                          return null;
                        } else if (name != null && name.trim().length > 140)
                          return 'Name cannot be more than 140 characters';
                        return 'Please enter your name';
                      },
                      onSaved: (name) {
                        _name = name!.trim();
                      },
                    ),
                  if (_authMode == AuthMode.signUp)
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (email) {
                        if (email != null &&
                            emailRegExp.hasMatch(email) &&
                            email.length <= 254) {
                          return null;
                        }
                        return 'Please enter a valid email';
                      },
                      onSaved: (email) {
                        _email = email!;
                      },
                    ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (username) {
                      if (username == null || username.isEmpty) {
                        return 'Please enter a username';
                      } else if (!usernameRegExp.hasMatch(username)) {
                        return 'Username can contain letters,digits and @, ., +, -, _ only';
                      } else if (username.length > 140) {
                        return 'Username cannot be more than 140 characters';
                      }
                    },
                    onSaved: (username) {
                      _username = username!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: _passwordController,
                    obscureText: true,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Please enter a password';
                      } else if (password.length > 140)
                        return 'Password cannot be more than 140 characters';
                    },
                    onSaved: (password) {
                      _password = password!;
                    },
                  ),
                  if (_authMode == AuthMode.signUp)
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      validator: (value) {
                        if (value == _passwordController.text) {
                          return null;
                        } else {
                          return 'Passwords are not matching';
                        }
                      },
                      obscureText: true,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  _loggingIn
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: Text(_authMode == AuthMode.signIn
                              ? 'Sign In'
                              : 'Sign Up'),
                        ),
                  // TextButton(
                  //   onPressed: _switchAuthMode,
                  //   child: Text(
                  //       _authMode == AuthMode.signIn ? 'Sign Up' : 'Sign In'),
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    child: Text(
                      _authMode == AuthMode.signIn
                          ? "Don't have an Account?  Sign Up"
                          : 'Existing User? Sign In',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onTap: _loggingIn ? null : _switchAuthMode,
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
