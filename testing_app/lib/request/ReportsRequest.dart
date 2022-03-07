import 'package:http/http.dart';
import '../model/ReportModel.dart';

String _hostname(){
return 'http://10.27.156.70:8080';
}

Future<ReportModel> makeGetMonthReportModelRequest() async {
  int year = 2021;
  int month = 12;
  String url = '${_hostname()}/report?year=$year&month=$month';
  Response response =  await get(url);
  int statusCode = response.statusCode;
  String jsonString = response.body;
  print(jsonString);
  ReportModel myModel = ReportModel.fromJson(jsonString);
  print(myModel.toString());
  print('Status: $statusCode, $myModel');
  return myModel;
}

void makeGetYearReportModelRequest() async {
    int year = 2021;
    int? month = null;
    String url = '${_hostname()}/report?year=$year&month=$month';
    Response response = await get(url);
    int statusCode = response.statusCode;
    String jsonString = response.body;
    print(jsonString);
    ReportModel myModel = ReportModel.fromJson(jsonString);
    print(myModel.toString());
    print('Status: $statusCode, $myModel');
}