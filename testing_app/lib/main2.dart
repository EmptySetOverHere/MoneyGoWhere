//生成dart doc
//flutter pub global activate dartdoc
//flutter pub global run dartdoc .
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:http/http.dart';
import 'dart:convert' show json;

import 'model/model_utils.dart';
import 'request/request_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Client App (Flutter)')),
        body: BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  static Map<String, String> headers = {"Content-type": "application/json"};
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                child: Text('Login'),
                onPressed: () {
                  Future<UserModel> future =
                      makeLoginRequest("123456@gg.com", "123456");
                  print("login processing...");
                  future.then((value) {
                    print("login successful");
                    print(value);
                    headers['uid'] = value.data?.id?.toString() as String;
                    headers['email'] = value.data?.email as String;
                    headers['password'] = "123456";
                    print(headers);
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
              RaisedButton(
                child: Text('Register'),
                onPressed: () {
                  Future<String> check = checkEmailRequest("123456@gg.com");
                  check.then((value) {
                    print("check email");
                    print(value);
                    print("here1");
                  }, onError: (e) {
                    print(e);
                  });

                  print("here2");

                  Future<String> future =
                      makeRegisterRequest("65448@gg.com", "1234567");
                  future.then((value) {
                    print("register");
                    print(int.parse("122"));
                    int uid = int.parse(value);
                    print("value: " + value);
                    if (uid > 0) {
                      print(
                          "successfully registered with uid:" + uid.toString());
                    } else {
                      print("register faild, error:" + uid.toString());
                    }

                    print("here3");
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
              RaisedButton(
                child: Text('Get default receipts'),
                onPressed: () {
                  Future<ReceiptsModel> future =
                      makeReceiptsRequest(headers, null);
                  future.then((value) {
                    print(value.data);
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
              RaisedButton(
                child: Text('Get receipts with filter'),
                onPressed: () {
                  SearchFilter filter = SearchFilter.fromParams(
                      content: "liho",
                      category: ["drink"],
                      priceLower: 0.33,
                      priceUpper: 0.88,
                      startDate: "01-12-2021",
                      endDate: "27-02-2022");
                  print(filter);
                  Future<ReceiptsModel> future =
                      makeReceiptsRequest(headers, filter);
                  future.then((value) {
                    print(value.data);
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
              RaisedButton(
                child: Text('Get merchant'),
                onPressed: () {
                  Future<MerchantsModel> future =
                      makeMerchantsRequest(headers, "each");
                  future.then((value) {
                    print(value.data);
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
              RaisedButton(
                child: Text('Get year report'),
                onPressed: () {
                  int year = 2021;
                  Future<ReportModel> future =
                      makeGetYearReportModelRequest(headers, year);
                  future.then((value) {
                    print(value.data);
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
              RaisedButton(
                child: Text('make sync request'),
                onPressed: () {
                  String jsonData =
                      '{"errorCode":0, "errorMsg":"error","data":[{"id":"123", "merchant":"Merchant1", "dateTime":"2022-02-28 12:00:03", "totalPrice": 123.56, "category":"food", "content":"nothing"}]}';
                  ReceiptsModel myModel = ReceiptsModel.fromJson(jsonData);
                  print(myModel);
                  Future<String> future = makeSyncRequest(headers, myModel);
                  future.then((value) {
                    print("done");
                    print(value);
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
              RaisedButton(
                child: Text('make delete receipt request'),
                onPressed: () {
                  String jsonData =
                      '{"id":"123", "merchant":"Merchant1", "dateTime":"2022-02-28 12:00:03", "totalPrice": 123.56, "category":"food", "content":"nothing", "index":2}';
                  ReceiptData receipt = ReceiptData.fromJson(jsonData);
                  Future<String> future =
                      makeDeleteReceiptRequest(headers, receipt);
                  future.then((value) {
                    print(value);
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
              RaisedButton(
                child: Text('make delete account request'),
                onPressed: () {
                  Future<String> future = makeDeleteAccountRequest(headers);
                  future.then((value) {
                    print("delete response");
                    print(value);
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
              RaisedButton(
                child: Text('make edit request'),
                onPressed: () {
                  Future<UserModel> future =
                      makeEditPhoneNumberRequest(headers, 12365478);
                  future.then((value) {
                    print("phone number updated");
                    print(value);
                  }, onError: (e) {
                    print(e);
                  });
                  Future<UserModel> future2 =
                      makeEditUserNameRequest(headers, "Jane");
                  future2.then((value) {
                    print("username updated");
                    print(value);
                  }, onError: (e) {
                    print(e);
                  });
                  Future<UserModel> future3 =
                      makeEditPasswordRequest(headers, "3399667");
                  future3.then((value) {
                    print("password updated");
                    print(value);
                  }, onError: (e) {
                    print(e);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
