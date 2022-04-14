import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../Model/User_Model.dart';
import '../Model/Message_Model.dart';
import '../Encrypt/Encrytion.dart';

import 'Api.dart';

const Map<String, String> config = {"Content-type": "application/json"};

/// login request.
/// [email], email of the user.
/// [password], password of the user.
/// if login is successful, returns [UserModel] containing user's information
Future<UserModel> makeLoginRequest_(String email, String password) async {
  Encryption.setKey(email);
  password = Encryption.encrypt(password);
  var jsonData = json.encode({"email": email, "password": password});
  print("making login request" + jsonData);
  Response response =
  await post(Uri.parse(Api.LOGIN), headers: config, body: jsonData);
  String jsonString = response.body;
  print(jsonString);
  UserModel myModel = UserModel.fromJson(jsonString);
  return myModel;
}

/// [email], email of the user.
/// [password], password of the user.
/// no matter register successful or unsuccessful, returns a message from the server
Future<MessageModel> makeRegisterRequest_(String email, String password) async {
  Encryption.setKey(email);
  password = Encryption.encrypt(password);
  var jsonData = json.encode({"email": email, "password": password});
  Response response =
  await post(Uri.parse(Api.REGISTER), headers: config, body: jsonData);
  return MessageModel.fromJson(response.body);
}

/// check if the current email has been registered.
/// this request should be called when the user changes the content in the email bar
Future<MessageModel> checkEmailRequest_(String email) async {
  var jsonData = json.encode({"email": email});
  // print("check email:" + email);
  Response response =
  await post(Uri.parse(Api.CHECKEMAIL), headers: config, body: jsonData);
  print(response.body);
  return MessageModel.fromJson(response.body);
}

/// sign out
/// user information are communicated through curHeaders
void makeSignOutRequest_(Map<String, String> curHeaders) async {
  Response response = await post(Uri.parse(Api.SIGNOUT), headers: curHeaders);
  print(response.body);
}
