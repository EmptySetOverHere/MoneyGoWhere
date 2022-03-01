import 'dart:convert' show json;

class ReceiptsModel {
  int? errorCode;
  String? errorMsg;
  List<ReceiptData>? data = [];

  ReceiptsModel.fromParams({this.errorCode, this.errorMsg, this.data});

  ReceiptsModel.fromJson(jsonRes) {
    if (jsonRes is String){
      jsonRes = json.decode(jsonRes);
    }
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = [];
    if(jsonRes['data'] !=null) {
      var tmp = jsonRes['data'];
      tmp.forEach((element) {
        ReceiptData receipt = new ReceiptData.fromJson(element);
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

class ReceiptData {
  String? id;
  String? merchant;
  String? dateTime;
  double? totalPrice;
  String? category;
  String? content;

  ReceiptData.fromParams(
      {this.id, this.merchant, this.dateTime, this.totalPrice, this.category, this.content});

  ReceiptData.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    id = jsonRes['id'];
    merchant = jsonRes['merchant'];
    dateTime = jsonRes['dateTime'];
    totalPrice = jsonRes['totalPrice'];
    category = jsonRes['category'];
    content = jsonRes['content'];
  }

  @override
  String toString() {
    return '{"id": "$id", "merchant": ${merchant != null ? '${json.encode(
        merchant)}' : 'null'},"dateTime": ${dateTime != null
        ? '${json.encode(dateTime)}'
        : 'null'},"totalPrice": $totalPrice, "category": ${category != null
        ? '${json.encode(category)}'
        : 'null'},"content": ${content != null
        ? '${json.encode(content)}'
        : 'null'}}';
  }
}
  void main() {
    String jsonData = '{"errorCode":0, "errorMsg":"error","data":[{"id":"123", "merchant":"Merchant1", "dateTime":"2022-2-28 12:00", "totalPrice": 123.56, "category":"food", "content":"nothing"}]}';

    ReceiptsModel myModel = ReceiptsModel.fromJson(jsonData);
    print(myModel.toString());

    print(myModel.data?.first.toString());
    ReceiptsModel myModel2 = ReceiptsModel.fromJson(myModel.toString());
    print(myModel2.toString());
  }
