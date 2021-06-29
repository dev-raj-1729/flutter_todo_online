import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:flutter_todo_online/widgets/todo_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<Api>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('To-do list'),
      ),
      body: ListView.builder(
          itemCount: apiProvider.todos.length,
          itemBuilder: (context, index) =>
              TodoTile(apiProvider.todos[index].title)),
    );
  }
}
