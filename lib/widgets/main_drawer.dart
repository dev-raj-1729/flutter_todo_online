import 'package:flutter/material.dart';
import 'package:flutter_todo_online/models/api.dart';
import 'package:provider/provider.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaData = MediaQuery.of(context);
    final apiProvider = Provider.of<Api>(context);
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: mediaData.padding.top),
          CircleAvatar(
            backgroundImage: apiProvider.userImage,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: Provider.of<Api>(context).signOut,
          )
        ],
      ),
    );
  }
}
