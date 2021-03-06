import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/api.dart';
import '../models/constants.dart';
import '../models/todo_item.dart';
import 'alert.dart';

class TodoForm extends StatefulWidget {
  final TodoItem? todoItem;
  TodoForm([this.todoItem]);

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }
    _formKey.currentState!.save();
    Navigator.of(context).pop();

    try {
      if (widget.todoItem == null) {
        await Provider.of<Api>(context, listen: false).addTodo(_title);
      } else {
        await Provider.of<Api>(context, listen: false)
            .updateById(widget.todoItem!.id!, _title);
      }
    } on Exception catch (e) {
      final message = ErrorMessages.getErrorMessage(e);
      Alerts.errorSnackBar(
          context,
          'Failed to ${widget.todoItem == null ? 'Add Todo' : 'Update Todo'}. '
          '$message');
    }
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
              decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              initialValue:
                  widget.todoItem != null ? widget.todoItem!.title : null,
              validator: (title) {
                if (title != null &&
                    title.trim().isNotEmpty &&
                    title.trim().length <= 140) {
                  return null;
                } else if (title != null && title.trim().length > 140) {
                  return 'Title cannot be more than 140 characters';
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
                child: Text(widget.todoItem == null ? 'Add' : 'Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
