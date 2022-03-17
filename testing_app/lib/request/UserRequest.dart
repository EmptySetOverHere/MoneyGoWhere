import 'dart:convert';
import 'package:http/http.dart';
import '../model/UserModel.dart';

import 'Api.dart';


const Map<String, String> headers = {"Content-type": "application/json"};

/// login request.
/// [email], email of the user.
/// [password], password of the user.
/// if login is successful, returns [UserModel] containing user's information
Future<UserModel> makeLoginRequest(String email, String password) async {
  var jsonData = json.encode({"email": email, "password": password});
  Response response = await post(Api.LOGIN, headers: headers, body: jsonData);
  String jsonString = response.body;
  UserModel myModel = UserModel.fromJson(jsonString);
  return myModel;
}

/// [email], email of the user.
/// [password], password of the user.
/// no matter register successful or unsuccessful, returns a message from the server
Future<String> makeRegisterRequest(String email, String password) async {
  var jsonData = json.encode({"email": email, "password": password});
  Response response =
      await post(Api.REGISTER, headers: headers, body: jsonData);
  return response.body;
}

/// check if the current email has been registered.
/// this request should be called when the user changes the content in the email bar
Future<String> checkEmailRequest(String email) async {
  var jsonData = json.encode({"email": email});
  // print("check email:" + email);
  Response response =
      await post(Api.CHECKEMAIL, headers: headers, body: jsonData);
  return response.body;
}

/// sign out
/// user information are communicated through curHeaders
void makeSignOutRequest(Map<String, String> curHeaders) async {
  Response response = await post(Api.SIGNOUT, headers: curHeaders);
  print(response.body);
}
