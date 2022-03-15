import 'package:http/http.dart';
import '../model/MerchantsModel.dart';
import 'Api.dart';



Future<MerchantsModel> makeMerchantsRequest(Map<String, String> curHeaders, String content) async{
  print("getMerchant");
  Response response = await get(Api.MERCHANTS + '?data=$content', headers: curHeaders);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  MerchantsModel myModel = MerchantsModel.fromJson(jsonString);
  return myModel;
}

// String _hostname(){
//   return 'http://10.27.156.70:8080';
// }
//
// void makeGetMerchantModelRequest() async{
//   String search = "each";
//   String url = '${_hostname()}/merchant?data=$search';
//   Response response = await get(url);
//   int statusCode = response.statusCode;
//   String jsonString = response.body;
//   print(jsonString);
//   MerchantsModel myModel = MerchantsModel.fromJson(jsonString);
//   print(myModel.toString());
//   print('Status: $statusCode, $myModel');
// }