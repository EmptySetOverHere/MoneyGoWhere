import '../Model/Receipt_Model.dart';



/// This is singleton class.
/// [LocalBuffer] is responsible to store the receipts from the merchant before syncing to the server.
class LocalBuffer{

  static LocalBuffer instance = LocalBuffer();

  ///list of [ReceiptData] stored locally.
  static List<ReceiptData> _localBuffer = [ReceiptData.fromJson('{"rid": "000002650608D", "merchant": "McDonald s North Spine NTU Branch", "address": "76 Nanyang Drive, #01-08, NTU Block N2, #1, Singapore", "postalCode": 637331, "dateTime": "2022-04-04 08:45:31", "totalPrice": 7.1000000000000005, "category": "Food", "content": "Credit Card Purchase VISA XXXXXXXXXXXX6556", "products": [{\"pname\":\"Origina Ice cream\",\"unitPrice\": 0.9, \"quantity\": 1}, {\"pname\":\"Filet TwFry Meal\",\"unitPrice\": 6.2, \"quantity\": 1}]}'),
    ReceiptData.fromJson('{"rid": "000001010471V", "merchant": "PRIME", "address": "50 Nanyang Avenue #01-26/27/28 North Spine", "postalCode": 639798, "dateTime": "2022-04-03 18:35:15", "totalPrice": 101.55000000000001, "category": "Groceries", "content": "Credit Card Purchase VISA XXXXXXXXXXXX7854", "products": [{\"pname\":\"CHERRY TOMATO\",\"unitPrice\": 4.2, \"quantity\": 3}, {\"pname\":\"FP VEGETABLE OIL\",\"unitPrice\": 7.9, \"quantity\": 4}, {\"pname\":\"NTUCF/P.W/BR420+80G\",\"unitPrice\": 2.65, \"quantity\": 3}, {\"pname\":\"CHERRY TOMATO\",\"unitPrice\": 4.2, \"quantity\": 2}, {\"pname\":\"KF BABY SPINACH 300G\",\"unitPrice\": 2.5, \"quantity\": 4}, {\"pname\":\"PSR F/CHK FEET\",\"unitPrice\": 2.0, \"quantity\": 5}, {\"pname\":\"CHERRY TOMATO\",\"unitPrice\": 4.2, \"quantity\": 5}]}')];

  /// put a [receipt] from a merchant into the [_localBuffer].
  static void push(ReceiptData receipt){
    _localBuffer.add(receipt);
  }

  /// check if [_localBuffer] is empty;
  static bool isEmpty(){
    return _localBuffer.isEmpty;
  }

  /// clear the local buffer
  static void clear(){
    _localBuffer.clear();
  }

  ///get all the receipts from the local buffer.
  static List<ReceiptData> getReceipts(){
    return _localBuffer;
  }



}