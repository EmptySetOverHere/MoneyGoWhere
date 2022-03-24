import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'request_utils.dart';
import '../model/model_utils.dart';

class NetManager {
  /// headers, store state information user information
  Map<String, String> config = {"Content-type": "application/json"};

  /// login request.
  /// [email], email of the user.
  /// [password], password of the user.
  /// if login is successful, returns [UserModel] containing user's information
  Future<UserModel> makeLoginRequest(String email, String password) async {
    Future<UserModel> future = makeLoginRequest_(email, password);
    future.then((value) {
      print("login successful");
      print(value);
      config['uid'] = value.data?.id?.toString() as String;
      config['email'] = value.data?.email as String;
      config['password'] = value.data?.password as String;
      print(config);
    }, onError: (e) {
      print(e);
    });
    return future;
  }

  Future<MessageModel> makeRegisterRequest(String email, String password) async {
    return makeRegisterRequest_(email, password);
  }

  /// check if the current email has been registered.
  /// this request should be called when the user changes the content in the email bar
  Future<MessageModel> checkEmailRequest(String email) async {
    return checkEmailRequest_(email);
  }

  /// sign out
  /// user information are communicated through curHeaders
  void makeSignOutRequest() async {
    makeSignOutRequest_(config);
    config['uid'] = "";
    config['email'] = "";
    config['password'] = "";
  }

  ///make search receipt request to the server.
  /// if [filter] is null, most recent receipts would be returned by default.
  /// Please see [SearchFilter] for detailed explanation of the attributes in the filter.
  /// This function returns [ReceiptsModel].
  Future<ReceiptsModel> makeReceiptsRequest(SearchFilter? filter) async {
    return makeReceiptsRequest_(config, filter);
  }

  /// make delete receipt request
  /// Receipt is identified by "uid" + index.
  /// This functions returns a message from the server.
  Future<MessageModel> makeDeleteReceiptRequest(ReceiptData receiptData) async {
    return makeDeleteReceiptRequest_(config, receiptData);
  }

  /// upload local copy of receipts to the server.
  /// [receiptsModel] is [ReceiptsModel] which stores list of [ReceiptData] in its data.
  /// This functions returns a message from the server.
  Future<MessageModel> makeSyncRequest(ReceiptsModel receiptsModel) async {
    return makeSyncRequest_(config, receiptsModel);
  }

  /// make get monthly report request to the server/
  /// [year], 'int'.
  /// [month], 'int'.
  /// This function returns [ReportModel] with [ReportData] as its data.
  Future<ReportModel> makeGetMonthReportModelRequest(
      int year, int month) async {
    return makeGetMonthReportModelRequest_(config, year, month);
  }

  /// make get year report request to the server/
  /// [year], 'int'.
  /// This function returns [ReportModel] with [ReportData] as its data.
  Future<ReportModel> makeGetYearReportModelRequest(int year) async {
    return makeGetYearReportModelRequest_(config, year);
  }

  /// make search merchant request to the server.
  /// [content] contains the content user has typed in the search bar.
  /// no filter is supported for searching merchant.
  /// if [content] is empty, i.e. "", recent merchant would be returned
  /// This function returns [MerchantsModel].
  Future<MerchantsModel> makeMerchantsRequest(String content) async {
    return makeMerchantsRequest_(config, content);
  }

  /// get user information from the server.
  /// returns [UserModel].
  Future<UserModel> makeGetAccountRequest() async {
    return makeGetAccountRequest_(config);
  }

  /// update phone Number with [newPhoneno].
  /// returns the updated [UserModel].
  Future<UserModel> makeEditPhoneNumberRequest(int newPhoneno) async {
    return makeEditPhoneNumberRequest_(config, newPhoneno);
  }

  /// update username with [newUsername].
  /// returns the updated [UserModel].
  Future<UserModel> makeEditUserNameRequest(String newUsername) async {
    return makeEditUserNameRequest_(config, newUsername);
  }

  /// update password with [newPassword].
  /// returns the updated [UserModel].
  Future<UserModel> makeEditPasswordRequest(String newPassword) async {
    return makeEditPasswordRequest_(config, newPassword);
  }

  /// delete current account.
  /// returns a message from the server.
  Future<MessageModel> makeDeleteAccountRequest() async {
    return makeDeleteAccountRequest_(config);
  }

  /// get Latitude and Longitude from google server
  /// [postalCode], 'int' postal of the merchant
  /// returns Latitude and Longitude
  Future<LatLng> getLatLong(int postalCode) async{
    return getLatLong_(postalCode);
  }
}
