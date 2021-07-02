import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/constants.dart';
import 'package:flutter_todo_online/models/todo_item.dart';
import 'package:flutter_todo_online/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api with ChangeNotifier {
  static const _apiEndpoint = 'https://todo-app-csoc.herokuapp.com';
  static const _register = 'auth/register';
  static const _login = 'auth/login';
  static const _profile = 'auth/profile/';
  static const _getTodos = 'todo/';
  static const _create = 'todo/create/';
  User? _user;
  NetworkImage? _userImage;
  String? _token;
  Map<String, String> _authHeader = {};
  // TODO : add / at end of all links
  List<TodoItem> _todos = [];
  Api() {
    _retrieveUserToken();
  }

  User? get user {
    if (_user == null) return null;
    return User(
        email: _user!.email, name: _user!.name, username: _user!.username);
  }

  ImageProvider? get userImage {
    return _userImage;
  }

  void _retrieveUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token == null) {
      _token = prefs.getString('token');
      print(_token);
      notifyListeners();
      if (_token != null) {
        _authHeader = {HttpHeaders.authorizationHeader: "Token $_token"};
        fetchUserInfo();
      }
    }
  }

  void _saveUserToken() async {
    if (_token == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
  }

  void _deleteUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  String _authErrorResolver(Map<String, dynamic>? emap) {
    if (emap == null) {
      return ErrorMessages.someError;
    } else if (emap['non_field_errors'] != null) {
      return ErrorMessages.invalidCred;
    } else {
      return emap.values.toList()[0][0];
    }
  }

  Future<void> fetchUserInfo() {
    return http
        .get(Uri.parse('$_apiEndpoint/$_profile'), headers: _authHeader)
        .then((response) {
      final responseData = json.decode(response.body);
      print(response.statusCode);
      print(responseData);
      _user = User.fromMap(responseData);
      notifyListeners();
      _userImage = NetworkImage('https://ui-avatars.com/api/'
          '?name=${_user!.name.replaceAll(" ", "+")}');
    });
  }

  Future<String?> signUp({
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
      if (response.statusCode != 200) {
        return _authErrorResolver(responseData);
      }
      _token = responseData['token'];
      _authHeader = {HttpHeaders.authorizationHeader: _token!};
      notifyListeners();
      _saveUserToken();
    });
  }

  Future<String?> signIn(String username, String password) {
    return http.post(Uri.parse('$_apiEndpoint/$_login/'), body: {
      "username": username,
      "password": password,
    }).then((response) {
      print(response.body);
      print(response.statusCode);
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        return _authErrorResolver(responseData);
      }
      _token = responseData['token'];
      _authHeader = {HttpHeaders.authorizationHeader: 'Token $_token'};
      notifyListeners();
      fetchUserInfo();
      _saveUserToken();
    });
  }

  void signOut() {
    _token = null;
    _todos = [];
    _authHeader = {};
    _user = null;
    _deleteUserToken();
    notifyListeners();
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
        if (response.statusCode != 200) {
          throw Exception("Try Again Later");
        }
        final responseData = json.decode(response.body);
        _todos = [];
        // TODO : Remove debug statements
        responseData.forEach(
          (map) {
            _todos.add(TodoItem.fromMap(map));
          },
        );
        notifyListeners();
      },
    );
  }

  Future<void> addTodo(String title) async {
    _todos.add(TodoItem(title));
    notifyListeners();
    try {
      await http
          .post(Uri.parse('$_apiEndpoint/$_create'),
              body: {"title": title}, headers: _authHeader)
          .then((response) {
        if (response.statusCode != 200) {
          throw Exception("Try Again Later");
        }
        fetchTodos();
      });
    } on Exception catch (_) {
      _todos.removeWhere(
          (element) => element.id == null && element.title == title);
      notifyListeners();
      rethrow;
    }
  }

  void removeById(int id) async {
    final index = _todos.indexWhere((element) => element.id == id);
    final temp = _todos[index];
    _todos.removeAt(index);
    notifyListeners();
    try {
      await http
          .delete(
        Uri.parse('$_apiEndpoint/$_getTodos${temp.id}/'),
        headers: _authHeader,
      )
          .then((response) {
        if (response.statusCode != 204) {
          throw Exception('Try Again Later');
        }
      });
    } catch (e) {
      _todos.insert(index, temp);
      notifyListeners();
      rethrow;
    }
  }

  void updateById(int id, String title) async {
    final index = _todos.indexWhere((element) => element.id == id);
    final temp = _todos[index].title;
    _todos[index].title = title;
    notifyListeners();
    try {
      await http
          .patch(
        Uri.parse('$_apiEndpoint/$_getTodos${_todos[index].id}/'),
        body: {"title": title},
        headers: _authHeader,
      )
          .then((response) {
        if (response.statusCode != 200) {
          throw Exception('Try Again Later');
        }
      });
    } catch (e) {
      _todos[index].title = temp;
      notifyListeners();
      rethrow;
    }
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
