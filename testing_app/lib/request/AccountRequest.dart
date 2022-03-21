import 'dart:convert';
import 'package:http/http.dart';
import 'package:testing_app/model/model_utils.dart';
import 'Api.dart';

/// get user information from the server.
/// user is identified by "uid" in the [curHeaders].
/// returns [UserModel].
Future<UserModel> makeGetAccountRequest_(Map<String, String> curHeaders) async {
  var jsonData = json.encode(
      {"email": curHeaders['email'], "password": curHeaders['password']});
  Response response =
      await post(Api.LOGIN, headers: curHeaders, body: jsonData);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  UserModel myModel = UserModel.fromJson(jsonString);
  return myModel;
}

/// update phone Number with [newPhoneno].
/// user is identified by "uid" in the [curHeaders].
/// returns the updated [UserModel].
Future<UserModel> makeEditPhoneNumberRequest_(
    Map<String, String> curHeaders, int newPhoneno) async {
  var jsonData = json.encode({"phoneno": newPhoneno});
  Response response =
      await patch(Api.ACCOUNT, headers: curHeaders, body: jsonData);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  UserModel myModel = UserModel.fromJson(jsonString);
  return myModel;
}

/// update username with [newUsername].
/// user is identified by "uid" in the [curHeaders].
/// returns the updated [UserModel].
Future<UserModel> makeEditUserNameRequest_(
    Map<String, String> curHeaders, String newUsername) async {
  var jsonData = json.encode({"username": newUsername});
  Response response =
      await patch(Api.ACCOUNT, headers: curHeaders, body: jsonData);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  UserModel myModel = UserModel.fromJson(jsonString);
  return myModel;
}

/// update password with [newPassword].
/// user is identified by "uid" in the [curHeaders].
/// returns the updated [UserModel].
Future<UserModel> makeEditPasswordRequest_(
    Map<String, String> curHeaders, String newPassword) async {
  var jsonData = json.encode({"password": newPassword});
  Response response =
      await patch(Api.ACCOUNT, headers: curHeaders, body: jsonData);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  UserModel myModel = UserModel.fromJson(jsonString);
  return myModel;
}

/// delete current account.
/// user is identified by "uid" in the [curHeaders].
Future<String> makeDeleteAccountRequest_(Map<String, String> curHeaders) async {
  Response response = await delete(Api.DELETEACCOUNT, headers: curHeaders);
  int statusCode = response.statusCode;
  return response.body;
}
