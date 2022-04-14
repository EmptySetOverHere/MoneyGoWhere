import 'dart:convert' show json;
import 'Receipt_Model.dart';

/// ReportModel can be used to
/// communicate merchant information with the server.
/// [errorCode], 'int', to identify if there is any error.
/// [errorMsg], 'String', details about the error.
/// [data], [ReportData] which stores the actual report information.
class ReportModel {
  ReportModel(this.errorCode, this.errorMsg, this.data);

  int? errorCode;
  String? errorMsg;
  ReportData? data;

  ///empty constructor
  ReportModel.fromEmpty();

  ///construct from parameters
  ReportModel.fromParams({this.errorCode, this.errorMsg, this.data});

  ///construct from jsonObject or json String
  ReportModel.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null
        ? null
        : new ReportData.fromJson(jsonRes['data']);
  }

  /// convert to json String
  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null ? '${json.encode(errorMsg)}' : 'null'},"data": $data}';
  }
}

/// an entity class that stores attributes of a report.
/// [totalExpenditure] total amount of money the user has spent in the selected year or month.
/// [unitExpenses], List of 'double', if this is a monthly report, then the length is the number of days in the month,
/// and if this is a year report, length would be 12.
/// [categoricalExpenses] map from category to expense, amount of money goes to each category.
/// [topReceipts] top 3 receipts with the highest totalPrice in the given year/month.
class ReportData {
  double? totalExpenditure;
  List<double>? unitExpenses;
  Map<String, dynamic>? categoricalExpenses;
  List<ReceiptData>? topReceipts = [];

  ///construct from parameters
  ReportData.fromParams(
      {this.totalExpenditure,
        this.unitExpenses,
        this.categoricalExpenses,
        this.topReceipts});

  ///construct from jsonObject or json String
  ReportData.fromJson(jsonRes) {
    if (jsonRes is String) {
      jsonRes = json.decode(jsonRes);
    }
    totalExpenditure = jsonRes['totalExpenditure'];
    unitExpenses = (jsonRes['unitExpenses'] as List)
        .map((item) => item as double)
        .toList();
    categoricalExpenses = jsonRes['categoricalExpenses'];
    if (jsonRes['topReceipts'] != null) {
      var tmp = jsonRes['topReceipts'];
      tmp.forEach((element) {
        ReceiptData receipt = new ReceiptData.fromJson(element);
        if (receipt != null) topReceipts?.add(receipt);
      });
    }
  }

  /// convert to json String
  @override
  String toString() {
    String? dataString = topReceipts?.join(",");
    return '{"totalExpenditure": $totalExpenditure, "unitExpenses": ${unitExpenses != null ? json.encode(unitExpenses) : 'null'},"categoricalExpenses": ${categoricalExpenses != null ? json.encode(categoricalExpenses) : 'null'},"topReceipts":[ $dataString ]}';
  }
}
