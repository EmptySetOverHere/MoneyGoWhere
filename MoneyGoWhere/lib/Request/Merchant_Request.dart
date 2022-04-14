import 'package:http/http.dart';
import '../Model/Merchant_Model.dart';
import 'Api.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert' show json;

/// make search merchant request to the server.
/// User is identified by "uid" in the [curHeaders].
/// [content] contains the content user has typed in the search bar.
/// no filter is supported for searching merchant.
/// if [content] is empty, i.e. "", recent merchant would be retlurned
/// This function returns [MerchantsModel].
Future<MerchantsModel> makeMerchantsRequest_(
    Map<String, String> curHeaders, String content) async {
  print("getMerchant");
  Response response = await post(Uri.parse(Api.MERCHANTS),headers: curHeaders, body:content);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  MerchantsModel myModel = MerchantsModel.fromJson(jsonString);
  print(myModel.toString());
  return myModel;
}

/// get Latitude and Longitude from google server
/// [postalCode], 'int' postal of the merchant
/// returns Latitude and Longitude
Future<LatLng> getLatLong_(int postalCode) async {
  print("get latitude and longitude from postalCode" + postalCode.toString());
  final r = await get(Uri.parse(Api.POSTALCODETOLATLONG +
      postalCode.toString() +
      "&key=AIzaSyDKKyOlWW3TvU3wldXJyEB1BQew0C02PHM"));

  if(r.statusCode == 200){
  var results = json.decode(r.body);
  print('google returned latlng');
  var location = results.values.first[0].values.elementAt(2).values.first;
  return LatLng(location.values.elementAt(0),
      location.values.elementAt(1));
}
  else{
    throw Exception('Cannot get latlng');
  }}