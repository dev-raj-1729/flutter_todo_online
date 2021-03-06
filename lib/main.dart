import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/api.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Api(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.amber,
        ),
        home: Consumer<Api>(
          builder: (context, auth, _) {
            if (auth.isLoggedIn()) {
              return HomeScreen();
            } else {
              return AuthScreen();
            }
          },
        ),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          AuthScreen.routeName: (context) => AuthScreen(),
        },
      ),
    );
  }
}
