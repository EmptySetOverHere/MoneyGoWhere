import 'dart:ui';

import 'package:flutter/material.dart';

import '../Displays/home.dart';
import '../Model/model_utils.dart';
import '../Request/NetManager.dart';

///user will enter their login credentials into the text bar.
///server will verify that the corresponding email and password are valid,
///On successful login, the user will be directed to Home().
class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //build scaffold for login page.
  //components are back button to login-register page, field to enter enail, field to enter password, button to login.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //back button to return to login-register page.
            AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor:
                  Colors.white.withOpacity(0), //You can make this transparent
              elevation: 0.0, //No shadow
            ),

            //Login page title.
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 70,
                child: Text(
                  'Login',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    fontSize: 40,
                  ),
                ),
              ),
            ),

            //Enter email.
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 80,
              child: TextFormField(
                controller: _emailController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter email here',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),

            //Enter password.
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 80,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Enter password here',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),

            //Login button.
            Container(
              height: 65,
              width: MediaQuery.of(context).size.width / 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black,
                  width: 4,
                ),
                color: Colors.black,
              ),
              child: Builder(
                builder: (context) => MaterialButton(
                  onPressed: () {
                    print('Login button pressed');
                    String userInputEmail = _emailController.text;
                    String userInputPassword = _passwordController.text;

                    Future<UserModel> future = NetManager.makeLoginRequest(
                        userInputEmail, userInputPassword);

                    future.then(
                      (value) {
                        if (value.errorCode! >= 0) {
                          print("Login successful!");

                          // ROUTE ME
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(filter: SearchFilter.empty()),
                            ),
                          );
                        } else {
                          print('Login not successful');
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                    'Email or password is invalid! Please enter again.'),
                              );
                            },
                          );
                        }
                      },
                      onError: (e) {
                        print(e);
                      },
                    );
                  },
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
