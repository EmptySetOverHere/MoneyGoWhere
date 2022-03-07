import 'dart:convert' show json;
import 'ReceiptModel.dart';

class ReportModel {
  ReportModel(this.errorCode, this.errorMsg, this.data);

  int? errorCode;
  String? errorMsg;
  ReportData? data;

  ReportModel.fromParams({this.errorCode, this.errorMsg, this.data});

  ReportModel.fromJson(jsonRes) {
    if (jsonRes is String){
      jsonRes = json.decode(jsonRes);
    }
    errorCode = jsonRes['errorCode'];
    errorMsg = jsonRes['errorMsg'];
    data = jsonRes['data'] == null ? null : new ReportData.fromJson(jsonRes['data']);
  }

  @override
  String toString() {
    return '{"errorCode": $errorCode,"errorMsg": ${errorMsg != null?'${json.encode(errorMsg)}':'null'},"data": $data}';
  }


}

class ReportData {
  double? totalExpenditure;
  List<double>? unitExpenses;
  Map<String, dynamic>? categoricalExpenses;
  List<ReceiptData>? topReceipts = [];

  ReportData.fromParams({this.totalExpenditure, this.unitExpenses, this.categoricalExpenses, this.topReceipts});

  ReportData.fromJson(jsonRes) {
    if (jsonRes is String){
      jsonRes = json.decode(jsonRes);
    }
    totalExpenditure = jsonRes['totalExpenditure'];
    unitExpenses = (jsonRes['unitExpenses'] as List).map((item) => item as double).toList();
    categoricalExpenses = jsonRes['categoricalExpenses'];
    if(jsonRes['topReceipts'] !=null) {
      var tmp = jsonRes['topReceipts'];
      tmp.forEach((element) {
        ReceiptData receipt = new ReceiptData.fromJson(element);
        if (receipt != null)
          topReceipts?.add(receipt);
      });
    }
  }

  @override
  String toString() {
    String? dataString = topReceipts?.join(",");
    return '{"totalExpenditure": $totalExpenditure, "unitExpenses": ${unitExpenses != null?json.encode(unitExpenses):'null'},"categoricalExpenses": ${categoricalExpenses != null?json.encode(categoricalExpenses):'null'},"topReceipts":[ $dataString ]}';
  }

}


void main() {
  String jsonData = '{"errorCode":0, "errorMsg":"error","data":{"totalExpenditure": 12.15, "unitExpense": [12.02, 32.54, 43.56, 23.4, 23.4],"categoricalExpense":{"food":12.35},"topReceipts":[{"id":"123", "merchant":"Merchant1", "dateTime":"2022-2-28 12:00", "totalPrice": 123.56, "category":"food", "content":"nothing"}]}}';

  ReportModel myModel = ReportModel.fromJson(jsonData);
  print(myModel.toString());

  ReportModel myModel2 =ReportModel.fromJson(myModel.toString());
  print(myModel2.toString());
}
