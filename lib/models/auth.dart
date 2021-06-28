import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/user.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static const _apiEndpoint = 'https://todo-app-csoc.herokuapp.com';
  static const _register = 'auth/register';
  static const _login = 'auth/login';
  static const _profile = 'auth/profile';
  User? _user;
  String? _token;
  Future<void> signIn({
    required String name,
    required String email,
    required String username,
    required String password,
  }) {
    _user = User(name: name, email: email, username: username);
    final client = http.Client();
    return client
        .post(Uri.parse('$_apiEndpoint/$_register'),
            body: json.encode({
              'name': name,
              'email': email,
              'username': username,
              'password': password,
            }))
        .then((response) {
      print(response.body);
      final responseData = json.decode(response.body);
      _token = responseData['token'];
    });
  }

  bool isLoggedIn() {
    return _token != null;
  }
}
