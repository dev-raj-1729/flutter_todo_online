import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/todo_item.dart';
import 'package:flutter_todo_online/models/user.dart';
import 'package:http/http.dart' as http;

class Api with ChangeNotifier {
  static const _apiEndpoint = 'https://todo-app-csoc.herokuapp.com';
  static const _register = 'auth/register';
  static const _login = 'auth/login';
  static const _profile = 'auth/profile';
  static const _getTodos = 'todo/';
  static const _create = 'todo/create/';
  User? _user;
  String? _token;

  List<TodoItem> _todos = [];

  Future<void> signUp({
    required String name,
    required String email,
    required String username,
    required String password,
  }) {
    _user = User(name: name, email: email, username: username);
    return http.post(Uri.parse('$_apiEndpoint/$_register/'), body: {
      "name": name,
      "email": email,
      "username": username,
      "password": password,
    }).then((response) {
      print(response.body);
      print(response.statusCode);
      final responseData = json.decode(response.body);
      _token = responseData['token'];
      notifyListeners();
    });
  }

  Future<void> signIn(String username, String password) {
    return http.post(Uri.parse('$_apiEndpoint/$_login/'), body: {
      "username": username,
      "password": password,
    }).then((response) {
      print(response.body);
      print(response.statusCode);
      final responseData = json.decode(response.body);
      _token = responseData['token'];
      notifyListeners();
    });
  }

  List<TodoItem> get todos {
    return [..._todos];
  }

  Future<void> fetchTodos() {
    return http.get(Uri.parse('$_apiEndpoint/$_getTodos')).then(
      (response) {
        final responseData =
            json.decode(response.body) as List<Map<String, dynamic>>;
        _todos = [];
        responseData.forEach(
          (map) {
            _todos.add(TodoItem.fromMap(map));
          },
        );
        notifyListeners();
      },
    );
  }

  void addTodo(String title) {
    _todos.add(TodoItem(title));
    notifyListeners();
  }

  void removeByIndex(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  void updateByIndex(int index, String title) {
    _todos[index].title = title;
    notifyListeners();
  }

  bool isLoggedIn() {
    return _token != null;
  }
}
