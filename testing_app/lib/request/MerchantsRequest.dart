import 'package:http/http.dart';
import '../model/MerchantsModel.dart';

String _hostname(){
  return 'http://10.27.156.70:8080';
}

void makeGetMerchantModelRequest() async{
  String search = "each";
  String url = '${_hostname()}/merchant?data=$search';
  Response response = await get(url);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  print(jsonString);
  MerchantsModel myModel = MerchantsModel.fromJson(jsonString);
  print(myModel.toString());
  print('Status: $statusCode, $myModel');
}