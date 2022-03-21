import 'package:http/http.dart';
import '../model/MerchantsModel.dart';
import 'Api.dart';

/// make search merchant request to the server.
/// User is identified by "uid" in the [curHeaders].
/// [content] contains the content user has typed in the search bar.
/// no filter is supported for searching merchant.
/// if [content] is empty, i.e. "", recent merchant would be returned
/// This function returns [MerchantsModel].
Future<MerchantsModel> makeMerchantsRequest_(
    Map<String, String> curHeaders, String content) async {
  print("getMerchant");
  Response response =
      await get(Api.MERCHANTS + '?data=$content', headers: curHeaders);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  MerchantsModel myModel = MerchantsModel.fromJson(jsonString);
  return myModel;
}
