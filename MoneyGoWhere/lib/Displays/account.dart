import 'package:cz2006/Displays/login_register.dart';
import 'package:cz2006/Model/Message_Model.dart';
import 'package:cz2006/Model/model_utils.dart';
import 'package:cz2006/Request/NetManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Displays/bottom_navigation_bar.dart';
import '../Storage/LocalBuffer.dart';

///Displays and allows for updating of account details,
///syncing of app details to server,
///and logging out or deletion of account.

class AccountPage extends StatefulWidget {
  AccountPage({Key? key}) : super(key: key);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  MyNavigationBar navigation_bar = MyNavigationBar(selected_index: 3);
  UserModel? userModel;

  List<TextEditingController> _controller = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool editEnabled = false;
  bool editEnabled2 = false;
  bool syncWithData = true;
  bool notLoaded = true;

  @override
  initState() {
    waitForServer();
  }

  //handles toggling the sync switch
  void toggleSwitch(bool value) {
    if (syncWithData == false) {
      setState(() {
        syncWithData = true;
      });
      print('Sync with data is ON');
    } else {
      setState(() {
        syncWithData = false;
      });
      print('Sync with data is OFF');
    }
  }

  //make request to server for account details
  //initialise UserModel received from server and texteditinccontrollers to display username and phonenumber from account.
  void waitForServer() async {
    await NetManager.makeGetAccountRequest().then((value) {
      setState(() {
        userModel = value;
        notLoaded = false;
        _controller = [
          TextEditingController(text: userModel?.data?.username),
          TextEditingController(
              text: userModel?.data?.phoneno.toString() as String),
        ];
      });
    });
  }

  //build scaffold for account page.
  //components of the page are profile picture, account details (email, username and phone number), delete account, sync, about the application and logout.
  //User can edit their username and phone number.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: ListView(
                children: <Widget>[
                  //profile picture and username.
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 5,
                          child:
                              Image.asset('assets/blank-profile-picture.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Row(children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                controller: _controller[0],
                                enabled: editEnabled,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  editEnabled = true;
                                });
                                String newUsername = _controller[0].text;
                                Future<UserModel> future =
                                    NetManager.makeEditUserNameRequest(
                                        newUsername);
                                future.then((value) {
                                  if (value.errorCode! >= 0) {
                                    value.data?.username = newUsername;
                                    print(
                                        'Username has been updated to $newUsername');
                                    _controller[0].text = newUsername;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(
                                              'Username has been updated to $newUsername'),
                                        );
                                      },
                                    );
                                  } else {
                                    print('Username failed to update');
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content:
                                              Text('Username failed to update'),
                                        );
                                      },
                                    );
                                  }
                                });
                              },
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),

                  //Account details: phone number and email.
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Account',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      editEnabled2 = true;
                                    });
                                    String newPhoneNo = _controller[1].text;
                                    Future<UserModel> future2 =
                                        NetManager.makeEditPhoneNumberRequest(
                                            int.parse(newPhoneNo));
                                    future2.then((value) {
                                      if (value.errorCode! >= 0) {
                                        value.data?.phoneno =
                                            int.parse(newPhoneNo);
                                        print(
                                            'Phone number has been updated to $newPhoneNo');
                                        _controller[1].text = newPhoneNo;
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(
                                                  'Phone number has been updated successfully to $newPhoneNo'),
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(
                                                  'Phone number failed to update successfully'),
                                            );
                                          },
                                        );
                                        print('Phone number failed to update');
                                      }
                                    });
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone',
                                style: TextStyle(fontSize: 18),
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                child: TextField(
                                  textAlign: TextAlign.end,
                                  controller: _controller[1],
                                  enabled: editEnabled2,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                userModel?.data?.email as String,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //Delete account.
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            onPressed: () {
                              print('Delete Account button pressed');
                              Future<MessageModel> _deleteAccount =
                                  NetManager.makeDeleteAccountRequest();
                              _deleteAccount.then(
                                (value) {
                                  if (value.errorCode! >= 0) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(
                                              'Account has been successfully deleted!'),
                                        );
                                      },
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LoginRegisterPage(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(
                                              'Delete account unsuccessful'),
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
                            child: Text(
                              'Delete Account',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        ),

                        //Sync switch.
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ListTile(
                            title: Text(
                              'Sync',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sync with 3G/4G',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Switch(
                                  onChanged: toggleSwitch,
                                  value: syncWithData,
                                  activeColor: Colors.pink,
                                  activeTrackColor: Colors.grey,
                                  inactiveTrackColor: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),

                        //sync with server.
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            color: Colors.white,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            onPressed: () async {
                              print('Sync button pressed');
                              if (!LocalBuffer.isEmpty()) {
                                List<ReceiptData> receipts =
                                    LocalBuffer.getReceipts();
                                await NetManager.makeSyncRequest(
                                        ReceiptsModel.fromParams(
                                            errorCode: 1,
                                            errorMsg: " ",
                                            data: receipts))
                                    .then((val) {
                                  if (val.errorCode! >= 0) {
                                    print('Data synced successfully!');
                                    LocalBuffer.clear();
                                  } else
                                    print('Data did not sync');
                                });
                              } else {
                                print("Local buffer is empty! no need to sync");
                              }
                            },
                            child: Text(
                              'Sync Now',
                              style: TextStyle(
                                color: Colors.pink.shade300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        //About the application.
                        ListTile(
                          title: Text(
                            'About',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Version',
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                              Text('1.0',
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                            ],
                          ),
                        ),

                        //logout of account.
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            color: Colors.white,
                          ),
                          child: Builder(
                            builder: (context) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              onPressed: () {
                                NetManager.makeSignOutRequest();
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
                                      content: Text(
                                          'Account successfully logged out!'),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: navigation_bar,
    );
  }
}
