import 'package:http/http.dart';
import '../model/MerchantsModel.dart';
import 'Api.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert' show json;

/// make search merchant request to the server.
/// User is identified by "uid" in the [curHeaders].
/// [content] contains the content user has typed in the search bar.
/// no filter is supported for searching merchant.
/// if [content] is empty, i.e. "", recent merchant would be returned
/// This function returns [MerchantsModel].
Future<MerchantsModel> makeMerchantsRequest_(
    Map<String, String> curHeaders, String content) async {
  print("getMerchant");
  Response response = await get(Uri.parse(Api.MERCHANTS + '?data=$content'),
      headers: curHeaders);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  MerchantsModel myModel = MerchantsModel.fromJson(jsonString);
  return myModel;
}

/// get Latitude and Longitude from google server
/// [postalCode], 'int' postal of the merchant
/// returns Latitude and Longitude
Future<LatLng> getLatLong(int postalCode) async {
  print("get latitude and longitude from adderss");
  Response r = await get(Uri.parse(Api.POSTALCODETOLATLONG +
      postalCode.toString() +
      "&key=AIzaSyDKKyOlWW3TvU3wldXJyEB1BQew0C02PHM"));
  var results = json.decode(r.body);
  return LatLng(results["geometry"]['location']['lat'],
      results['geometry']['location']['long']);
}
