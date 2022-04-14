import 'dart:ui';

import 'package:flutter/material.dart';

import '../Model/Message_Model.dart';
import '../Request/NetManager.dart';
import 'login_register.dart';

/// User enters password to register their account with the server.

class RegisterPagePassword extends StatefulWidget {
  RegisterPagePassword({Key? key}) : super(key: key);

  @override
  _RegisterPagePasswordState createState() => _RegisterPagePasswordState();
}

class _RegisterPagePasswordState extends State<RegisterPagePassword> {
  final TextEditingController _passwordController = TextEditingController();

  //build scaffold for register-password page.
  //components include: back button to return to register-email page, text field to enter password and register account button.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //back button to return to register-email page.
            AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor:
                  Colors.white.withOpacity(0), //You can make this transparent
              elevation: 0.0, //No shadow
            ),

            //Register password title.
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 100,
                child: Text(
                  'Register Password',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    fontSize: 40,
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

            //register account button.
            Container(
              height: 65,
              width: MediaQuery.of(context).size.width / 1.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black,
                  width: 4,
                ),
// <<<<<<< Updated upstream
                color: Colors.black,
              ),
              child: Builder(
                builder: (context) => MaterialButton(
                  onPressed: () {
                    print('Register password button pressed');
                    String userInputPassword = _passwordController.text;
                    if (userInputPassword.length >= 8) {
                      Future<MessageModel> future =
                          NetManager.makeRegisterRequest(
                              store.get("email"), userInputPassword);

                      future.then((value) {
                        if (value.errorCode! >= 0) {
                          print("successfully registered");

                          // ROUTE ME
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginRegisterPage(),
                            ),
                          );
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text('Account created successfully!'),
                              );
                            },
                          );
                        } else {
                          print("register failed, error:" +
                              value.errorMsg.toString());
                        }
                        print("here3");
                      }, onError: (e) {
                        print(e);
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(
                                'Password needs to be at least 8 characters long!'),
                          );
                        },
                      );
                    }
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

            //hint text on requirements for password.
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
              child: Text(
                'Password must contain at least 8 characters',
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// idk what this is lol
class GlobalState {
  final Map<dynamic, dynamic> _data = <dynamic, dynamic>{};

  static GlobalState instance = GlobalState._();
  GlobalState._();

  set(dynamic key, dynamic value) => _data[key] = value;
  get(dynamic key) => _data[key];
}

final GlobalState store = GlobalState.instance;
