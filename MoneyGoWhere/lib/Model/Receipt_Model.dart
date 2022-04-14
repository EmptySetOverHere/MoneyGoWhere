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

  ///empty constructor
  ReceiptsModel.empty();

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

  /// convert to json String
  @override
  String toStringForServer() {
    List<String> dataString = [];
    data?.forEach((element){
      dataString.add(element.toStringForServer());
    });
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null ? '${json.encode(errorMsg)}' : 'null'},"data":[ ${dataString.join(",")} ]}';
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
  String? address;
  String? dateTime;
  double? totalPrice;
  String? category;
  String? content;
  int? index;
  List<Product>? products = [];

  ///empty constructor
  ReceiptData.empty();

  ///construct from parameters
  ReceiptData.fromParams(
      {this.id,
        this.merchant,
        this.postalCode,
        this.address,
        this.dateTime,
        this.totalPrice,
        this.category,
        this.content,
        this.products,
        this.index});

  ///construct from jsonObject or json String
  ReceiptData.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    id = jsonRes['id'];
    merchant = jsonRes['merchant'];
    postalCode = jsonRes['postalCode'];
    address = jsonRes['address'];
    dateTime = jsonRes['dateTime'];
    totalPrice = jsonRes['totalPrice'];
    category = jsonRes['category'];
    content = jsonRes['content'];
    products = [];
    if (jsonRes['products'] != null) {
      var tmp = jsonRes['products'];
      // print(tmp);
      if (tmp is String) {
        tmp = json.decode(tmp);
      }
      tmp.forEach((element) {
        Product p = Product.fromJson(element);
        // print(p.toString());
        products?.add(p);
      });
    }
    index = jsonRes['index'] as int;
  }

  /// convert to json String
  @override
  String toString() {
    String? productsString = products?.join(",");
    return '{"id": "$id", "merchant": ${merchant != null ? json.encode(merchant) : 'null'}, "postalCode": $postalCode ,"address": ${address != null ? json.encode(address) : 'null'},"dateTime": ${dateTime != null ? '${json.encode(dateTime)}' : 'null'},"totalPrice": $totalPrice, "category": ${category != null ? '${json.encode(category)}' : 'null'},"content": ${content != null ? '${json.encode(content)}' : 'null'}, "products": [$productsString], "index": $index}';
  }

  /// convert to json String for server
  String toStringForServer() {
    String? productsString = products?.join("\',\'");
    print(productsString);
    return '{"id": "$id", "merchant": ${merchant != null ? json.encode(merchant) : 'null'}, "postalCode": $postalCode ,"address": ${address != null ? json.encode(address) : 'null'},"dateTime": ${dateTime != null ? '${json.encode(dateTime)}' : 'null'},"totalPrice": $totalPrice, "category": ${category != null ? '${json.encode(category)}' : 'null'},"content": ${content != null ? '${json.encode(content)}' : 'null'}, "products": [\'$productsString\'], "index": "$index"}';
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

  ///empty contructor
  SearchFilter.empty();

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
    return '{"content":${content != null ? '${json.encode(content)}' : 'null'}, "category": ${category != null ? '${json.encode(category)}' : '[]'}, "priceUpper": ${priceUpper != null ? '${json.encode(priceUpper)}' : 'null'}, "priceLower": ${priceLower != null ? '${json.encode(priceLower)}' : 'null'}, "startDate": ${startDate != null ? '${json.encode(startDate)}' : 'null'}, "endDate": ${endDate != null ? '${json.encode(endDate)}' : 'null'}}';
  }
}



/// an entity class used to store name, price and quantity of a product inside the ReceiptData
/// [pname], String,  Product name.
/// [unitPrice], double, the price of the product.
/// [quantity], int, quantity of the product purchased.
class Product {
  String pname = "";
  double unitPrice = 0.0;
  int quantity = 0;

  ///construct from parameters
  Product.fromParas(this.pname, this.unitPrice, this.quantity);

  ///construct from jsonObject or json String
  Product.fromJson(jsonRes){
    if(jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }

    pname = jsonRes['pname'];
    unitPrice = jsonRes['unitPrice'];
    quantity = jsonRes['quantity'];
  }

  /// convert to json String
  @override
  String toString(){
    return '{"pname": "$pname", "unitPrice": $unitPrice, "quantity": $quantity}';
  }



}