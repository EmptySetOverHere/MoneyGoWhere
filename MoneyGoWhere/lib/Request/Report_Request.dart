import 'package:http/http.dart';
import '../Model/Report_Model.dart';
import 'Api.dart';
import '../Encrypt/Encrytion.dart';

/// make get monthly report request to the server/
/// User is identified by "uid" in the [curHeaders].
/// [year], 'int'.
/// [month], 'int'.
/// This function returns [ReportModel] with [ReportData] as its data.
Future<ReportModel> makeGetMonthReportModelRequest_(
    Map<String, String> curHeaders, int year, int month) async {
  String url = '${Api.REPORTS}?year=$year&month=$month';
  Response response = await get(Uri.parse(url), headers: curHeaders);
  int statusCode = response.statusCode;
  print(response.body);
  ReportModel myModel = ReportModel.fromJson(response.body);
  myModel.data?.topReceipts?.forEach((element) {
    element.content = Encryption.decrypt(element.content as String);
  });
  print(myModel.toString());
  return myModel;
}

/// make get year report request to the server/
/// User is identified by "uid" in the [curHeaders].
/// [year], 'int'.
/// This function returns [ReportModel] with [ReportData] as its data.
Future<ReportModel> makeGetYearReportModelRequest_(
    Map<String, String> curHeaders, int year) async {
  int? month = null;
  String url = '${Api.REPORTS}?year=$year&month=$month';
  Response response = await get(Uri.parse(url), headers: curHeaders);
  ReportModel myModel = ReportModel.fromJson(response.body);
  myModel.data?.topReceipts?.forEach((element) {
    element.content = Encryption.decrypt(element.content as String);
  });
  print(myModel.toString());
  return myModel;
}