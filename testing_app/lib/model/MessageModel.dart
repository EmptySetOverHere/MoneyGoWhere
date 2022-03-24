import 'dart:convert' show json;
/// MessageModel can be used to
/// communicate Error Message with the server.
/// [errorCode], 'int', to identify if there is any error.
/// [errorMsg], 'String', details about the error.
class MessageModel {
  int? errorCode;
  String? errorMsg;

  ///construct from parameters
  MessageModel.fromParams({this.errorCode, this.errorMsg});

  ///construct from jsonObject or json String
  MessageModel.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
  }
}