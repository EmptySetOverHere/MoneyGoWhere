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
                  Future<UserModel> future = makeLoginRequest("123456@gg.com", "123456");
                  future.then((value) { print(value); if(value.errorCode! > 0 ){
                    headers['email'] = "123456@gg.com";
                    headers['password'] = "123456";
                  };},
                      onError: (e) { print(e); });

                },
              ),
              RaisedButton(
                child: Text('Register'),
                onPressed: () {
                  Future<String> check = checkEmailRequest("livelycloud@e.ntu.edu.sg");
                  check.then((value) { print(value); print("here1");},
                      onError: (e) { print(e); });
                  print("here2");
                  Future<String> future = makeRegisterRequest("123456@gg.com", "123456");
                  future.then((value) { print(value); print("here3");},
                      onError: (e) { print(e); });

                },
              ),
              RaisedButton(
                child: Text('Get default receipts'),
                onPressed: () {
                  UserModel model = makeReceiptsRequest(headers, null) as UserModel;
                  print(model.data);
                },
              ),
              RaisedButton(
                child: Text('Get receipts with filter'),
                onPressed: () {
                  SearchFilter filter = SearchFilter.fromParams(content: "liho", category: ["drink"], priceRange: {'start':0.33, 'end': 0.88},
                      dateRange:{'start': "01-12-2021", 'end': "27-2-2022"});
                  print(filter);
                  UserModel model = makeReceiptsRequest(headers, filter) as UserModel;
                  print(model.data);
                },
              ),
              RaisedButton(
                child: Text('Get merchant'),
                onPressed: () {
                  Future<MerchantsModel> future = makeMerchantsRequest(headers, "each");
                  future.then((value) { print(value.data); },
                      onError: (e) { print(e); });
                },
              ),
              RaisedButton(
                child: Text('Get year report'),
                onPressed: () {
                  int year = 2021;
                  Future<ReportModel>  future = makeGetYearReportModelRequest(headers, year);
                  future.then((value) { print(value.data); },
                      onError: (e) { print(e); });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }








}
