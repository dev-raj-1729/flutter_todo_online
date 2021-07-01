import 'dart:convert';
import 'dart:io';
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
  Map<String, String> _authHeader = {};
  // TODO : add / at end of all links
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
      _authHeader = {HttpHeaders.authorizationHeader: _token!};
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
      _authHeader = {HttpHeaders.authorizationHeader: 'Token $_token'};
      notifyListeners();
    });
  }

  List<TodoItem> get todos {
    return [..._todos];
  }

  Future<void> fetchTodos() {
    print(_authHeader);
    return http
        .get(Uri.parse('$_apiEndpoint/$_getTodos'), headers: _authHeader)
        .then(
      (response) {
        final responseData = json.decode(response.body);
        _todos = [];
        // TODO : Remove debug statements
        print(responseData);
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
    http
        .post(Uri.parse('$_apiEndpoint/$_create'),
            body: {"title": title}, headers: _authHeader)
        .then((response) {
      print(response.body);
      fetchTodos();
    });
  }

  void removeById(int id) {
    print(id);
    final index = _todos.indexWhere((element) => element.id == id);
    final temp = _todos[index];
    _todos.removeAt(index);
    notifyListeners();
    http
        .delete(
      Uri.parse('$_apiEndpoint/$_getTodos${temp.id}/'),
      headers: _authHeader,
    )
        .then((value) {
      notifyListeners();
      print(value.statusCode);
    });
  }

  void updateById(int id, String title) {
    final index = _todos.indexWhere((element) => element.id == id);
    _todos[index].title = title;
    notifyListeners();
    http
        .patch(
          Uri.parse('$_apiEndpoint/$_getTodos${_todos[index].id}/'),
          body: {"title": title},
          headers: _authHeader,
        )
        .then(
          (value) => print(value.statusCode),
        );
  }

  List<TodoItem> searchFor(String sub) {
    return sub.isEmpty
        ? []
        : _todos
            .where((element) =>
                element.title.toLowerCase().startsWith(sub.toLowerCase()))
            .toList();
  }

  bool isLoggedIn() {
    return _token != null;
  }
}
