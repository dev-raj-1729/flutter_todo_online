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
      child: apiProvider.user != null
          ? Column(
              children: [
                SizedBox(height: mediaData.padding.top),
                SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  backgroundImage: apiProvider.userImage,
                  radius: 40,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  apiProvider.user!.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '@${apiProvider.user!.username}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(apiProvider.user!.email),
                Divider(
                  color: Colors.black,
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: Provider.of<Api>(context).signOut,
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
