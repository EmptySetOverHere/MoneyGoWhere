import 'dart:io';

import 'package:http/http.dart';
import '../model/ReceiptModel.dart';

import 'Api.dart';

///make search receipt request to the server.
/// User is identified by "uid" in the [curHeaders].
/// if [filter] is null, most recent receipts would be returned by default.
/// Please see [SearchFilter] for detailed explanation of the attributes in the filter.
/// This function returns [ReceiptsModel].
Future<ReceiptsModel> makeReceiptsRequest_(
    Map<String, String> curHeaders, SearchFilter? filter) async {
  var jsonData = filter.toString();
  Response response =
      await post(Api.RECEIPTS, headers: curHeaders, body: jsonData);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  ReceiptsModel myModel = ReceiptsModel.fromJson(jsonString);
  return myModel;
}

/// make delete receipt request
/// User is identified by "uid" in the [curHeaders].
/// Receipt is identified by "uid" + index.
/// This functions returns a message from the server.
Future<String> makeDeleteReceiptRequest_(
    Map<String, String> curHeaders, ReceiptData receiptData) async {
  var index = receiptData.index;
  Response response =
      await delete(Api.DELETERECEIPT + "?index=$index", headers: curHeaders);
  int statusCode = response.statusCode;
  return response.body;
}

/// upload local copy of receipts to the server.
/// User is identified by "uid" in the [curHeaders].
/// [receiptsModel] is [ReceiptsModel] which stores list of [ReceiptData] in its data.
/// This functions returns a message from the server.
Future<String> makeSyncRequest_(
    Map<String, String> curHeaders, ReceiptsModel receiptsModel) async {
  Response response =
      await post(Api.SYNC, headers: curHeaders, body: receiptsModel.toString());
  int statusCode = response.statusCode;
  return response.body;
}
