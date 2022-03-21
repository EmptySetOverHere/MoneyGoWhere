import 'dart:convert' show json;

/// Receipt Model can be used to
/// communicate receipt information with the server.
/// [errorCode], 'int', to identify if there is any error.
/// [errorMsg], 'String', details about the error.
/// [data], list of [ReceiptData] which stores the actual receipt information.
class ReceiptsModel {
  int? errorCode;
  String? errorMsg;
  List<ReceiptData>? data = [];

  ///construct from parameters
  ReceiptsModel.fromParams({this.errorCode, this.errorMsg, this.data});

  ///construct from jsonObject or json String
  ReceiptsModel.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = [];
    if (jsonRes['data'] != null) {
      var tmp = jsonRes['data'];
      tmp.forEach((element) {
        ReceiptData receipt = new ReceiptData.fromJson(element);
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

/// an entity class that stores attributes of a receipt.
/// [id] id of the receipt given by the merchant, 'String'.
/// [merchant] merchant, 'String'.
/// [dateTime] dateTime when the receipt is printed, format: "yyyy-MM-dd HH:mm:ss", String.
/// [totalPrice] total price of the receipt, 'double'.
/// [category] category, 'String', e.g. "Grocery", "Food".
/// [content] the detailed content in the receipt, which may includes individual items, payment method.
/// Can be used to display the receipt.
/// [index] index of the receipt given by the server.
/// Receipt can be identified by [merchant] + [id] + [dateTime], or [uid] of the user + [index].
class ReceiptData {
  String? id;
  String? merchant;
  int? postalCode;
  String? dateTime;
  double? totalPrice;
  String? category;
  String? content;
  int? index;

  ///construct from parameters
  ReceiptData.fromParams(
      {this.id,
      this.merchant,
      this.postalCode,
      this.dateTime,
      this.totalPrice,
      this.category,
      this.content,
      this.index});

  ///construct from jsonObject or json String
  ReceiptData.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    id = jsonRes['id'];
    merchant = jsonRes['merchant'];
    postalCode = jsonRes['postalCode'];
    dateTime = jsonRes['dateTime'];
    totalPrice = jsonRes['totalPrice'];
    category = jsonRes['category'];
    content = jsonRes['content'];
    index = jsonRes['index'];
  }

  /// convert to json String
  @override
  String toString() {
    return '{"id": "$id", "merchant": ${merchant != null ? '${json.encode(merchant)}' : 'null'},"postalCode": "$postalCode","dateTime": ${dateTime != null ? '${json.encode(dateTime)}' : 'null'},"totalPrice": $totalPrice, "category": ${category != null ? '${json.encode(category)}' : 'null'},"content": ${content != null ? '${json.encode(content)}' : 'null'}, "index": "$index"}';
  }
}

/// an entity class used to store information to search for receipts.
/// all attributes are nullable.
/// [content], 'String', the content user typed in the search bar.
/// [category], List of 'Stirng' that user has selected in the filter.
/// [priceUpper], 'double', upper limit of the price range.
/// [priceLower], 'double', lower limit of the price range.
/// [startDate], 'String', start date, format: "dd-MM-yyyy".
/// [endDate], 'String', end date, format: "dd-MM-yyyy".
class SearchFilter {
  String? content;
  List<String>? category = [];
  double? priceUpper;
  double? priceLower;
  String? startDate;
  String? endDate;

  ///construct from parameters
  SearchFilter.fromParams(
      {this.content,
      this.category,
      this.priceUpper,
      this.priceLower,
      this.startDate,
      this.endDate});

  ///construct from jsonObject or json String
  SearchFilter.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    content = jsonRes['content'];
    category = jsonRes['category'];
    priceUpper = jsonRes['priceUpper'];
    priceLower = jsonRes['priceLower'];
    startDate = jsonRes['startDate'];
    endDate = jsonRes['endDate'];
  }

  /// convert to json String
  @override
  String toString() {
    return '{"content":${content != null ? '${json.encode(content)}' : 'null'}, "category": ${category != null ? '${json.encode(category)}' : 'null'}, "priceUpper": ${priceUpper != null ? '${json.encode(priceUpper)}' : 'null'}, "priceLower": ${priceLower != null ? '${json.encode(priceLower)}' : 'null'}, "startDate": ${startDate != null ? '${json.encode(startDate)}' : 'null'}, "endDate": ${endDate != null ? '${json.encode(endDate)}' : 'null'}}';
  }
}

/// a simple test, if the above methods work properly
void main() {
  String jsonData =
      '{"errorCode":0, "errorMsg":"error","data":[{"id":"123", "merchant":"Merchant1", "dateTime":"2022-02-28 12:00", "totalPrice": 123.56, "category":"food", "content":"nothing", "index":2}]}';

  ReceiptsModel myModel = ReceiptsModel.fromJson(jsonData);
  print(myModel.toString());

  print(myModel.data?.first.toString());
  ReceiptsModel myModel2 = ReceiptsModel.fromJson(myModel.toString());
  print(myModel2.toString());
}
