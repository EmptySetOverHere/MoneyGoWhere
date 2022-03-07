import 'dart:convert';

import 'package:http/http.dart';
import '../model/UserModel.dart';

String _hostname(){
  return 'http://10.27.156.70:8080';
}

const Map<String, String> headers = {"Content-type": "application/json"};

void makeGetUserModelRequest() async{
  var jsonData = json.encode({"username": "username", "password": "password"});
  Response response = await post('${_hostname()}/home', headers: headers, body: jsonData);
  // examples of info available in response
  int statusCode = response.statusCode;
  String jsonString = response.body;
  print(jsonString);
  UserModel myModel = UserModel.fromJson(jsonString);
  print(myModel.toString());
  print('Status: $statusCode, $myModel');
}