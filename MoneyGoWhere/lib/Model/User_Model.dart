import 'dart:convert' show json;

/// UserModel can be used to
/// communicate user information with the server.
/// [errorCode], 'int', to identify if there is any error.
/// [errorMsg], 'String', details about the error.
/// [data], list of [UserData] which stores the actual user information.
class UserModel {
  int? errorCode;
  String? errorMsg;
  UserData? data;

  ///construct from parameters
  UserModel.fromParams({this.errorCode, this.errorMsg, this.data});

  ///construct from jsonObject or json String
  UserModel.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data =
    jsonRes['data'] == null ? null : new UserData.fromJson(jsonRes['data']);
  }

  /// convert to json String
  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null ? '${json.encode(errorMsg)}' : 'null'},"data": $data}';
  }
}

/// an entity class that stores attributes of a user
/// [id] id of the user, given by the server, 'int'
/// [email] email of the user, 'String'
/// [password] password of the user, 'String'
/// [username] username of the user, 'String'
/// [phoneno] phone number of the user, 'int'
class UserData {
  int? id;
  String? email;
  String? password;
  String? username;
  int? phoneno;

  ///construct from parameters
  UserData.fromParams(
      {this.id, this.email, this.password, this.username, this.phoneno});

  ///construct from jsonObject or json String
  UserData.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    id = jsonRes['id'];
    email = jsonRes['email'];
    password = jsonRes['password'];
    username = jsonRes['username'];
    phoneno = int.parse(jsonRes['phoneno']);
  }

  /// convert to json String
  @override
  String toString() {
    return '{"id": $id, "email": ${email != null ? '${json.encode(email)}' : 'null'},"password": ${password != null ? '${json.encode(password)}' : 'null'},"username": ${username != null ? '${json.encode(username)}' : 'null'},"phoneno":${phoneno != null ? '${json.encode(phoneno)}' : 'null'}}';
  }
}