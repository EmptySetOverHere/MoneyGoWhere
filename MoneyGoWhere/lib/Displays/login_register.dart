import 'package:flutter/material.dart';
import '../Displays/login.dart';
import '../Displays/register_page_email.dart';

/// Directs users to login page or register page.
/// After registering for an account, user is redirected to this page to login with their newly created account.

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({Key? key}) : super(key: key);

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  //build scaffold for login-register page.
  //components are generic picture of receipts, login button and register button.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //picture of receipts.
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.3,
                child: Image.asset('assets/moneygowherefrontscreen.jpg'),
              ),

              //login and register buttons.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 2.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      color: Colors.white,
                    ),
                    child: Builder(
                      builder: (context) => MaterialButton(
                        onPressed: () {
                          print('Login button pressed');
                          // ROUTE ME
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 2.3,
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
                          print('Register button pressed');
                          // ROUTE ME
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPageEmail(),
                            ),
                          );
                        },
                        child: const Text(
                          'REGISTER',
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
            ],
          ),
        ),
    );
  }
}