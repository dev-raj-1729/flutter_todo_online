import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      height: 400,
      padding: EdgeInsets.all(15),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'email',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'username',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
