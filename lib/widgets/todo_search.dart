import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:flutter_todo_online/widgets/todo_tile.dart';
import 'package:provider/provider.dart';

class TodoSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultList = Provider.of<Api>(context).searchFor(query);
    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, index) => TodoTile(
        resultList[index],
        index,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = Provider.of<Api>(context).searchFor(query);
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index].title),
        onTap: () {
          query = suggestionList[index].title;
        },
      ),
    );
  }
}
