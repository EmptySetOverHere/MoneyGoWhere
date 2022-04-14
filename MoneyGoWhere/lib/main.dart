import 'package:cz2006/Displays/login_register.dart';
import 'package:flutter/material.dart';

import '/Model/Receipt_Model.dart';
import 'Displays/home.dart';

///main class for the project.
///initially open to login-register page.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginRegisterPage(), routes: {
      '/home': (context) => HomePage(filter: SearchFilter.empty()),
    });
  }
}
