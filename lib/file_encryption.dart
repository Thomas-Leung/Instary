import 'package:encrypt/encrypt.dart' as encrypt;

class FileEncryption {
  // for AES Encryption/ Decryption
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  //encrypt.Key.fromUtf8('a32bitPasswordthatsuitsyourneeds')
  //encrpyt.IV.fromUtf8('a16bitInitVector')
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAES(text) {
    final encrypted = encrypter.encryptBytes(text, iv: iv);

    print(encrypted.bytes);
    print(encrypted.base16);
    print(encrypted.base64);
    return encrypted;
  }

  static decryptAES(_bytes) {
    encrypt.Encrypted en = new encrypt.Encrypted(_bytes);
    final decrypted = encrypter.decryptBytes(en, iv: iv);
    print(decrypted);
    return decrypted;
  }

  // convertToBytes
  // file.writeAsByte("Encrypted Data")
  // TODO:
  // WRITE DATA: Zip -> convert to Byte -> Encrypt -> export
  // READ DATA: readAsByte -> Uint8List -> decrypt -> write as byte -> instary
}
