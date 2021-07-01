import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:flutter_todo_online/models/todo_item.dart';
import 'package:provider/provider.dart';

class TodoForm extends StatefulWidget {
  final TodoItem? todoItem;
  TodoForm([this.todoItem]);

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';

  void _submitForm() {
    if (_formKey.currentState!.validate() == false) {
      return;
    }
    _formKey.currentState!.save();
    if (widget.todoItem == null) {
      Provider.of<Api>(context, listen: false).addTodo(_title);
    } else {
      Provider.of<Api>(context, listen: false)
          .updateById(widget.todoItem!.id!, _title);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              initialValue:
                  widget.todoItem != null ? widget.todoItem!.title : null,
              validator: (title) {
                if (title != null && title.trim().isNotEmpty) {
                  return null;
                }
                return "Title cannot be empty";
              },
              onSaved: (title) {
                _title = title!;
              },
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text('Ok'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
