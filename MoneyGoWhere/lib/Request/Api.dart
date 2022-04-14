///stores all the URL for requests
///if the ip address of the server changes, please update [ROOT]
class Api {
  static const String ROOT = "http://10.27.198.93:8085";

  static const String LOGIN = ROOT + "/login";
  static const String REGISTER = ROOT + "/register";
  static const String CHECKEMAIL = ROOT + "/checkemail";
  static const String SIGNOUT = ROOT + "/signout";
  static const String RECEIPTS = ROOT + "/receipts";
  static const String MERCHANTS = ROOT + "/merchant";
  static const String REPORTS = ROOT + "/report";
  static const String ACCOUNT = ROOT + "/updateaccount";
  static const String DELETEACCOUNT = ROOT + "/deleteaccount";
  static const String DELETERECEIPT = ROOT + "/deletereceipt";
  static const String SYNC = ROOT + "/sync";
  static const String POSTALCODETOLATLONG =
      "https://maps.googleapis.com/maps/api/geocode/json?components=country:SG|postal_code:";
}