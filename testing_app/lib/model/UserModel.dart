import 'dart:convert' show json;

class UserModel {

  int? errorCode;
  String? errorMsg;
  UserData? data;

  UserModel.fromParams({this.errorCode, this.errorMsg, this.data});

  // factory UserModel(jsonStr) => jsonStr == null ? null : jsonStr is String ? new UserModel.fromJson(json.decode(jsonStr)) : new UserModel.fromJson(jsonStr);

  UserModel.fromJson(jsonRes) {
    if (jsonRes is String){
      jsonRes = json.decode(jsonRes);
    }
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : new UserData.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'},"data": $data}';
  }
}

class UserData {

  int? id;
  String? email;
  String? password;
  String? username;
  int? phoneNumber;


  UserData.fromParams({this.id, this.email, this.password, this.username, this.phoneNumber});

  UserData.fromJson(jsonRes) {
    if (jsonRes is String){
      jsonRes = json.decode(jsonRes);
    }
    id = jsonRes['id'];
    email = jsonRes['email'];
    password = jsonRes['password'];
    username = jsonRes['username'];
    phoneNumber = jsonRes['phoneNumber'];
  }

  @override
  String toString() {
    return '{"id": $id, "email": ${email != null?
    '${json.encode(email)}':'null'},"password": ${password != null?
    '${json.encode(password)}':'null'},"username": ${username != null?
    '${json.encode(username)}':'null'},"phoneNumber":${phoneNumber != null?
    '${json.encode(phoneNumber)}':'null'}}';
  }
}

void main(){
  UserData myData = UserData.fromParams(id: 123, email:"email", password: "password",username: "username",phoneNumber:88335566);
  UserModel myModel = UserModel.fromParams(errorCode: 0, errorMsg: "No", data: myData);
  print(myData.toString());
  print(myModel.toString());

  UserModel myModel2 = UserModel.fromJson(myModel.toString());
  print(myModel2.toString());

}