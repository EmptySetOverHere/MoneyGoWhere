import 'dart:convert' show json;

/// MerchantsModel can be used to
/// communicate merchant information with the server.
/// [errorCode], 'int', to identify if there is any error.
/// [errorMsg], 'String', details about the error.
/// [data], list of [MerchantData] which stores the actual merchant information.
class MerchantsModel {
  int? errorCode;
  String? errorMsg;
  List<MerchantData>? data = [];

  ///construct from parameters
  MerchantsModel.fromParams({this.errorCode, this.errorMsg, this.data});

  ///construct from jsonObject or json String
  MerchantsModel.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = [];
    if (jsonRes['data'] != null) {
      var tmp = jsonRes['data'];
      tmp.forEach((element) {
        MerchantData receipt = new MerchantData.fromJson(element);
        if (receipt != null) data?.add(receipt);
      });
    }
  }

  /// convert to json String
  @override
  String toString() {
    String? dataString = data?.join(",");
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null ? '${json.encode(errorMsg)}' : 'null'},"data":[ $dataString ]}';
  }
}

/// an entity class that stores attributes of a merchant
/// [name] name of the merchant, 'String'
/// [postalCode] postal code of the merchant, 'int'
/// [category] category of the merchant, 'String', e.g. "Grocery", "Food"
/// [address] address of the merchant, 'double'
/// [totalExpense] amount of money the user has spent in this merchant, 'double' (?in the last month?)
/// merchant can be identified by [name]
class MerchantData {
  String? name;
  int? postalCode;
  String? category;
  String? address;
  double? totalExpense;

  ///construct from parameters
  MerchantData.fromParams(
      {this.name,
      this.postalCode,
      this.category,
      this.address,
      this.totalExpense});

  ///construct from jsonObject or json String
  MerchantData.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    name = jsonRes['name'];
    postalCode = jsonRes['postalCode'];
    category = jsonRes['category'];
    address = jsonRes['address'];
    totalExpense = jsonRes['totalExpense'];
  }

  /// convert to json String
  @override
  String toString() {
    return '{"name": "$name", "postalCode": ${postalCode != null ? json.encode(postalCode) : 'null'},"category": ${category != null ? json.encode(category) : 'null'},"address": "$address","totalExpense": ${totalExpense != null ? json.encode(totalExpense) : 'null'}}';
  }
}

/// a simple test, if the above methods work properly
void main() {
  String jsonData =
      '{"errorCode":0, "errorMsg":"error","data":[{"name":"each a cup","postalCode":123456, "category": "drink", "address":"66 NS", "totalExpense":123.56 }]}';

  MerchantsModel myModel = MerchantsModel.fromJson(jsonData);
  print(myModel.toString());

  print(myModel.data?.first.toString());
  MerchantsModel myModel2 = MerchantsModel.fromJson(myModel.toString());
  print(myModel2.toString());
}
