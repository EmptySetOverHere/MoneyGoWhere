import 'dart:io';

import 'package:cz2006/Encrypt/Encrytion.dart';
import 'package:http/http.dart';
import '../Model/Message_Model.dart';
import '../Model/Receipt_Model.dart';
import '../Encrypt/Encrytion.dart';

import 'Api.dart';

///make search receipt request to the server.
/// User is identified by "uid" in the [curHeaders].
/// if [filter] is null, most recent receipts would be returned by default.
/// Please see [SearchFilter] for detailed explanation of the attributes in the filter.
/// This function returns [ReceiptsModel].
Future<ReceiptsModel> makeReceiptsRequest_(
    Map<String, String> curHeaders, SearchFilter? filter) async {
  var jsonData = filter.toString();
  print(jsonData);
  Response response =
  await post(Uri.parse(Api.RECEIPTS), headers: curHeaders, body: jsonData);
  int statusCode = response.statusCode;
  print(statusCode.toString());
  String jsonString = response.body;
  print(jsonString);
  ReceiptsModel myModel = ReceiptsModel.fromJson(jsonString);
  myModel.data?.forEach((element) {
    element.content = Encryption.decrypt(element.content as String);
  });

  print(myModel.toString());
  return myModel;
}

/// make delete receipt request
/// User is identified by "uid" in the [curHeaders].
/// Receipt is identified by "uid" + index.
/// This functions returns a message from the server.
Future<MessageModel> makeDeleteReceiptRequest_(
    Map<String, String> curHeaders, ReceiptData receiptData) async {
  var index = receiptData.index;
  Response response = await delete(
      Uri.parse(Api.DELETERECEIPT + "?index=$index"),
      headers: curHeaders);
  int statusCode = response.statusCode;
  return MessageModel.fromJson(response.body);
}

/// upload local copy of receipts to the server.
/// User is identified by "uid" in the [curHeaders].
/// [receiptsModel] is [ReceiptsModel] which stores list of [ReceiptData] in its data.
/// This functions returns a message from the server.
Future<MessageModel> makeSyncRequest_(
    Map<String, String> curHeaders, ReceiptsModel receiptsModel) async {
  ReceiptsModel tmpModel = ReceiptsModel.fromJson(receiptsModel.toString());
  tmpModel.data?.forEach((element) {
    element.content = Encryption.encrypt(element.content as String);
  });
  print(tmpModel.toString());
  Response response = await post(Uri.parse(Api.SYNC),
      headers: curHeaders, body: tmpModel.toStringForServer());
  int statusCode = response.statusCode;
  return MessageModel.fromJson(response.body);
}
