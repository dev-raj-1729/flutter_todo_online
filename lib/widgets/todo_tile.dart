import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/api.dart';
import '../models/constants.dart';
import '../models/todo_item.dart';
import 'alert.dart';
import 'todo_form.dart';

class TodoTile extends StatelessWidget {
  final TodoItem todoItem;
  final int index;
  final void Function(String message) showError;
  const TodoTile(this.todoItem, this.index, this.showError);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      child: Dismissible(
        key: Key((todoItem.id ?? DateTime.now()).toString()),
        onDismissed: (_) async {
          try {
            await Provider.of<Api>(context, listen: false)
                .removeById(todoItem.id!);
          } on Exception catch (e) {
            final message = ErrorMessages.getErrorMessage(e);
            showError('Failed to Delete Todo. $message');
          }
        },
        direction: todoItem.id == null
            ? DismissDirection.none
            : DismissDirection.startToEnd,
        confirmDismiss: (_) => Alerts.confirmDelete(context),
        background: Container(
          // color: Colors.red,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.red),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
        ),
        child: Container(
          // color: Colors.amber,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.amber),

          child: ListTile(
            title: Text(
              todoItem.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: todoItem.id == null
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => TodoForm(todoItem),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
