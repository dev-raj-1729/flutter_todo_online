import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:provider/provider.dart';

class TodoTile extends StatelessWidget {
  final String title;
  final int index;
  const TodoTile(this.title, this.index);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(index.toString()),
      onDismissed: (_) {
        Provider.of<Api>(context, listen: false).removeByIndex(index);
      },
      child: Card(
        child: ListTile(
          title: Text(title),
        ),
      ),
    );
  }
}
