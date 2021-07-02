import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:flutter_todo_online/models/constants.dart';
import 'package:flutter_todo_online/models/todo_item.dart';
import 'package:flutter_todo_online/widgets/alert.dart';
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
                child: Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
