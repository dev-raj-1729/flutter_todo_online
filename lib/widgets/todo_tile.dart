import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:flutter_todo_online/models/constants.dart';
import 'package:flutter_todo_online/models/todo_item.dart';
import 'package:flutter_todo_online/widgets/alert.dart';
import 'package:flutter_todo_online/widgets/todo_form.dart';
import 'package:provider/provider.dart';

class TodoTile extends StatelessWidget {
  final TodoItem todoItem;
  final int index;
  final void Function(String message) showError;
  const TodoTile(this.todoItem, this.index, this.showError);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
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
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        padding: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
      ),
      child: Card(
        child: ListTile(
          title: Text(todoItem.title),
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
    );
  }
}
