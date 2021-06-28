import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/constants.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.signIn;
  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.signIn) {
        _authMode = AuthMode.signUp;
      } else {
        _authMode = AuthMode.signIn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      height: _authMode == AuthMode.signIn ? 300 : 420,
      padding: EdgeInsets.all(15),
      child: Card(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Form(
            child: Column(
              children: [
                if (_authMode == AuthMode.signUp)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                if (_authMode == AuthMode.signUp)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                      _authMode == AuthMode.signIn ? 'Sign In' : 'Sign Up'),
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      _authMode == AuthMode.signIn ? 'Sign Up' : 'Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
