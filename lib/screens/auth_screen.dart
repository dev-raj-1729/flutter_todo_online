import 'package:flutter/material.dart';
import 'package:flutter_todo_online/widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AuthForm(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
