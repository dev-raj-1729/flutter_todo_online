import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/api.dart';

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
                  foregroundImage: apiProvider.userImage,
                  backgroundImage: AssetImage('assets/images/blank-avatar.png'),
                  onForegroundImageError: (_, __) => {},
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
