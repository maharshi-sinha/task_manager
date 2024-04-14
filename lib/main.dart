import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/screens/LoginScreen.dart';
import 'package:task_manager/screens/TaskScreen.dart';
import 'package:task_manager/viewmodel/task_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskViewmodel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.hasError || !snapshot.data!) {
                return LoginScreen();
              } else {
                return TaskScreen();
              }
            }
          },
        ),
      ),
    );
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    // Check if email and password are not null and not empty
    return email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }
}
