import 'package:http/http.dart';
import '../model/ReportModel.dart';
import 'Api.dart';


Future<ReportModel> makeGetMonthReportModelRequest(Map<String, String> curHeaders, int year, int month) async {
  String url = '${Api.REPORTS}?year=$year&month=$month';
  Response response =  await get(url, headers: curHeaders);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  print(jsonString);
  ReportModel myModel = ReportModel.fromJson(jsonString);
  print(myModel.toString());
  print('Status: $statusCode, $myModel');
  return myModel;
}

Future<ReportModel> makeGetYearReportModelRequest(Map<String, String> curHeaders, int year) async {
    int? month = null;
    String url = '${Api.REPORTS}?year=$year&month=$month';
    Response response = await get(url,  headers: curHeaders);
    int statusCode = response.statusCode;
    String jsonString = response.body;
    print(jsonString);
    ReportModel myModel = ReportModel.fromJson(jsonString);
    print(myModel.toString());
    print('Status: $statusCode, $myModel');
    return myModel;
}