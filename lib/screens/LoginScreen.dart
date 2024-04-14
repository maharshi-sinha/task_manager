import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/constants/constants.dart';
import 'package:task_manager/screens/Signup.dart';
import 'package:task_manager/screens/TaskScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> saveCredentials() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
    }

    Future<void> login(BuildContext context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');

      if (email != null && password != null) {
        // Implement your login logic here
        // For example, validate user credentials
        // If valid, navigate to the next screen
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TaskScreen();
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up first'),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 100, color: Colors.white),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: new BorderSide(color: Colors.teal)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                saveCredentials();
                login(context);
              },
              child: Text('Login'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                saveCredentials();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SignUpScreen();
                }));
              },
              child: Text('Sign Up'),
            )
          ],
        ),
      ),
    );
  }
}
