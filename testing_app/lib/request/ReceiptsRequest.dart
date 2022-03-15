import 'package:http/http.dart';
import '../model/ReceiptModel.dart';

import 'Api.dart';

Future<ReceiptsModel> makeReceiptsRequest(Map<String, String> curHeaders, SearchFilter? filter) async{
  var jsonData = filter.toString();
  Response response = await post(Api.RECEIPTS, headers: curHeaders, body: jsonData);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  ReceiptsModel myModel = ReceiptsModel.fromJson(jsonString);
  return myModel;
}

