import 'package:encrypt/encrypt.dart';

/// Encryption is used to encrypt password and content of the receipt.
/// This class is a singleton class.
/// AES Encryption is used.
class Encryption{

  static Encryption instance = Encryption();

  static Key _key = Key.fromUtf8("default");
  static IV _iv = IV.fromLength(7);
  static Encrypter _encrypter = Encrypter(AES(Key.fromUtf8("default")));

  ///set the key using input [keyText]
  static void setKey(String keyText){
    _key = Key.fromUtf8(keyText.substring(0, 16));
    _iv = IV.fromLength(keyText.length % 16 );
    _encrypter = Encrypter(AES(_key));
  }

  ///encrypt [text] and return the [encryptedText] as String, base64.
  static String encrypt(String text){
    // print("encrypt " + text);
    String encryptedText = _encrypter.encrypt(text, iv: _iv).base64;
    // print("after encryption" + encryptedText);
    return encryptedText;
  }

  ///decrypt [text] which is a  base64 String and return the decrypted text.
  static String decrypt(String text){
    Encrypted encryptedText = Encrypted.fromBase64(text);
    return _encrypter.decrypt(encryptedText, iv: _iv);
  }

}


// use to generate encryted content for receipts
// void main(){
//
//   Encryption.setKey("group3@gmail.com");
//   String text = "by Cash";
//   print("Entrypt " + text + " into " + Encryption.encrypt(text));
//   text = "Credit Card Purchase VISA XXXXXXXXXXXX6556";
//   print("Entrypt " + text + " into " + Encryption.encrypt(text));
//   text = "Credit Card Purchase VISA XXXXXXXXXXXX7854";
//   print("Entrypt " + text + " into " + Encryption.encrypt(text));
//
// }