import 'dart:convert' show json;

class MerchantsModel {
  int? errorCode;
  String? errorMsg;
  List<MerchantData>? data = [];

  MerchantsModel.fromParams({this.errorCode, this.errorMsg, this.data});

  MerchantsModel.fromJson(jsonRes) {
    if (jsonRes is String){
      jsonRes = json.decode(jsonRes);
    }
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = [];
    if(jsonRes['data'] !=null) {
      var tmp = jsonRes['data'];
      tmp.forEach((element) {
        MerchantData receipt = new MerchantData.fromJson(element);
        if (receipt != null)
          data?.add(receipt);
      });
    }
  }

  @override
  String toString() {
    String? dataString = data?.join(",");
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'},"data":[ $dataString ]}';
  }


}

class MerchantData {
  String? name;
  int? postalCode;
  String? category;
  String? address;
  double? totalExpense;


  MerchantData.fromParams(
      {this.name, this.postalCode, this.category, this.address, this.totalExpense});

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

  @override
  String toString() {
    return '{"name": "$name", "postalCode": ${postalCode != null ? json.encode(
        postalCode) : 'null'},"category": ${category != null
        ? json.encode(category)
        : 'null'},"address": "$address","totalExpense": ${totalExpense != null
        ? json.encode(totalExpense)
        : 'null'}}';
  }
}
void main() {
  String jsonData = '{"errorCode":0, "errorMsg":"error","data":[{"name":"each a cup","postalCode":123456, "category": "drink", "address":"66 NS", "totalExpense":123.56 }]}';

  MerchantsModel myModel = MerchantsModel.fromJson(jsonData);
  print(myModel.toString());

  print(myModel.data?.first.toString());
  MerchantsModel myModel2 = MerchantsModel.fromJson(myModel.toString());
  print(myModel2.toString());
}
