import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:provider/provider.dart';

class TodoForm extends StatefulWidget {
  final int? index;
  TodoForm([this.index]);

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
    if (widget.index == null) {
      Provider.of<Api>(context, listen: false).addTodo(_title);
    } else {
      Provider.of<Api>(context, listen: false)
          .updateByIndex(widget.index!, _title);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
            initialValue: widget.index != null
                ? Provider.of<Api>(context, listen: false)
                    .todos[widget.index!]
                    .title
                : null,
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
          Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Text('Ok'),
            ),
          ),
        ],
      ),
    );
  }
}
