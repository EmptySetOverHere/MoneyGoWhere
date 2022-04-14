import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Model/model_utils.dart';
import 'request_utils.dart';


/// This a singleton class.
/// This is a control class to communicate with the servers.
class NetManager {
  static NetManager instance = NetManager();

  /// headers, store state information user information
  static Map<String, String> config = {"Content-type": "application/json"};


  /// login request.
  /// [email], email of the user.
  /// [password], password of the user.
  /// if login is successful, returns [UserModel] containing user's information

  static Future<UserModel> makeLoginRequest(
      String email, String password) async {
    Future<UserModel> future = makeLoginRequest_(email, password);
    future.then((value) {
      config['uid'] = value.data?.id?.toString() as String;
      config['email'] = value.data?.email as String;
      config['password'] = value.data?.password as String;
    }, onError: (e) {
      print(e);
    });
    return future;
  }

  /// [email], email of the user.
  /// [password], password of the user.
  /// register with the latest email that has been checked.
  /// no matter register successful or unsuccessful, returns a MessageModel from the server
  static Future<MessageModel> makeRegisterRequest(
      String email, String password) async {
    return makeRegisterRequest_(email, password);
  }

  /// [email], email of the user.
  /// [password], password of the user.
  /// no matter register successful or unsuccessful, returns a MessageModel from the server
  static Future<MessageModel> makeRegisterRequest2(String password) async {
    return makeRegisterRequest_(config['email'] as String, password);
  }

  /// check if the current email has been registered.
  /// this request should be called when the user changes the content in the email bar
  static Future<MessageModel> checkEmailRequest(String email) async {
    config['email'] = email;
    return checkEmailRequest_(email);
  }

  /// sign out
  /// user information are communicated through curHeaders
  static void makeSignOutRequest() async {
    makeSignOutRequest_(config);
    config['uid'] = "";
    config['email'] = "";
    config['password'] = "";
  }

  ///make search receipt request to the server.
  /// if [filter] is null, most recent receipts would be returned by default.
  /// Please see [SearchFilter] for detailed explanation of the attributes in the filter.
  /// This function returns [ReceiptsModel].
  static Future<ReceiptsModel> makeReceiptsRequest(SearchFilter? filter) async {
    return makeReceiptsRequest_(config, filter);
  }

  /// make delete receipt request
  /// Receipt is identified by "uid" + index.
  /// This functions returns a message from the server.
  static Future<MessageModel> makeDeleteReceiptRequest(
      ReceiptData receiptData) async {
    return makeDeleteReceiptRequest_(config, receiptData);
  }

  /// upload local copy of receipts to the server.
  /// [receiptsModel] is [ReceiptsModel] which stores list of [ReceiptData] in its data.
  /// This functions returns a message from the server.
  static Future<MessageModel> makeSyncRequest(
      ReceiptsModel receiptsModel) async {
    return makeSyncRequest_(config, receiptsModel);
  }

  /// make get monthly report request to the server/
  /// [year], 'int'.
  /// [month], 'int'.
  /// This function returns [ReportModel] with [ReportData] as its data.
  static Future<ReportModel> makeGetMonthReportModelRequest(
      int year, int month) async {
    return makeGetMonthReportModelRequest_(config, year, month);
  }

  /// make get year report request to the server/
  /// [year], 'int'.
  /// This function returns [ReportModel] with [ReportData] as its data.
  static Future<ReportModel> makeGetYearReportModelRequest(int year) async {
    return makeGetYearReportModelRequest_(config, year);
  }

  /// make search merchant request to the server.
  /// [content] contains the content user has typed in the search bar.
  /// no filter is supported for searching merchant.
  /// if [content] is empty, i.e. "", recent merchant would be returned
  /// This function returns [MerchantsModel].
  static Future<MerchantsModel> makeMerchantsRequest(String content) async {
    return makeMerchantsRequest_(config, content);
  }

  /// get user information from the server.
  /// returns [UserModel].
  static Future<UserModel> makeGetAccountRequest() async {
    return makeGetAccountRequest_(config);
  }

  /// update phone Number with [newPhoneno].
  /// returns the updated [UserModel].
  static Future<UserModel> makeEditPhoneNumberRequest(int newPhoneno) async {
    return makeEditPhoneNumberRequest_(config, newPhoneno);
  }

  /// update username with [newUsername].
  /// returns the updated [UserModel].
  static Future<UserModel> makeEditUserNameRequest(String newUsername) async {
    return makeEditUserNameRequest_(config, newUsername);
  }

  /// update password with [newPassword].
  /// returns the updated [UserModel].
  static Future<UserModel> makeEditPasswordRequest(String newPassword) async {
    return makeEditPasswordRequest_(config, newPassword);
  }

  /// delete current account.
  /// returns a message from the server.
  static Future<MessageModel> makeDeleteAccountRequest() async {
    return makeDeleteAccountRequest_(config);
  }

  /// get Latitude and Longitude from google server
  /// [postalCode], 'int' postal of the merchant
  /// returns Latitude and Longitude
  static Future<LatLng> getLatLong(int postalCode) async {
    return getLatLong_(postalCode);
  }
}
