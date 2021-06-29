import 'package:flutter/material.dart';

class TodoTile extends StatelessWidget {
  final String title;

  const TodoTile(this.title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
    );
  }
}
