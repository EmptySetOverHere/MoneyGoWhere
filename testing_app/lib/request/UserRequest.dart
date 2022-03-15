import 'dart:convert';
import 'package:http/http.dart';
import '../model/UserModel.dart';

import 'Api.dart';



const Map<String, String> headers = {"Content-type": "application/json"};


Future<UserModel> makeLoginRequest(String email, String password) async{
  var jsonData = json.encode({"email": email, "password":password});
  Response response = await post(Api.LOGIN, headers: headers, body: jsonData);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  UserModel myModel = UserModel.fromJson(jsonString);
  return myModel;
}

Future<UserModel> makeRegisterRequest(String email, String password) async{
  var jsonData = json.encode({"email": email, "password":password});
  Response response = await post(Api.REGISTER, headers: headers, body: jsonData);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  UserModel myModel = UserModel.fromJson(jsonString);
  return myModel;
}

Future<String> checkEmailRequest(String email) async{
  var jsonData = json.encode({"email": email});
  print("check email:"+email);
  Response response = await post(Api.CHECKEMAIL, headers: headers, body: jsonData);
  return response.body;
}

void makeSignOutRequest(Map<String, String> curHeaders) async{
  Response response = await post(Api.SIGNOUT, headers: curHeaders);
  print(response.body);
}


// String _hostname(){
//   return 'http://10.27.156.70:8080';
// }
// void makeGetUserModelRequest() async{
//   var jsonData = json.encode({"username": "username", "password": "password"});
//   Response response = await post('${_hostname()}/home', headers: headers, body: jsonData);
//   // examples of info available in response
//   int statusCode = response.statusCode;
//   String jsonString = response.body;
//   print(jsonString);
//   UserModel myModel = UserModel.fromJson(jsonString);
//   print(myModel.toString());
//   print('Status: $statusCode, $myModel');
// }