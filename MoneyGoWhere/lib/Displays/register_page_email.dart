import 'package:flutter/material.dart';

// import '../pages/pages.dart';
import '../Model/Message_Model.dart';
import '../Request/NetManager.dart';
import 'register_page_password.dart';

/// For user to create a new account by entering a unique email.
/// This page will make a request to the server to check whether the email is valid and does not exist in the database
/// before user can proceed to entering their password.
class RegisterPageEmail extends StatefulWidget {
  RegisterPageEmail({Key? key}) : super(key: key);

  @override
  _RegisterPageEmailState createState() => _RegisterPageEmailState();
}

class _RegisterPageEmailState extends State<RegisterPageEmail> {
  final TextEditingController _emailController = TextEditingController();

  //build scaffold for register-email page
  //components are back button to return to login-register page, field to enter email, button to check validity of email.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //back button to return to login-register page
              AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor:
                    Colors.white.withOpacity(0), //You can make this transparent
                elevation: 0.0, //No shadow
              ),

              //Register email title
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 70,
                  child: Text(
                    'Register Email',
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

              //Register button to check email validity with server.q
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
                      print('Register email button pressed');

                      String userInputEmail = _emailController.text;
                      store.set("email", userInputEmail);
                      Future<MessageModel> check =
                          NetManager.checkEmailRequest(userInputEmail);

                      check.then(
                        (value) {
                          if (value.errorCode! >= 0) {
                            print('Email is valid!');
                            // ROUTE ME
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPagePassword(),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                      'Email already exists or is invalid! Please enter another email.'),
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
