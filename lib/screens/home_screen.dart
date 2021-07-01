import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:flutter_todo_online/widgets/todo_form.dart';
import 'package:flutter_todo_online/widgets/todo_search.dart';
import 'package:flutter_todo_online/widgets/todo_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void>? _fetch;
  Future<void> fetch(BuildContext context) {
    if (_fetch != null) {
      return _fetch!;
    } else {
      _fetch = Provider.of<Api>(context, listen: false).fetchTodos();
      return _fetch!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final apiProvider = Provider.of<Api>(context);?

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('To-do list'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: TodoSearch());
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: FutureBuilder<void>(
          future: fetch(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final apiProvider = Provider.of<Api>(context);
            return RefreshIndicator(
              onRefresh: apiProvider.fetchTodos,
              child: ListView.builder(
                itemCount: apiProvider.todos.length,
                itemBuilder: (context, index) =>
                    TodoTile(apiProvider.todos[index].title, index),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => TodoForm(),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
