part of base2e15.x;

class X2e15Crypt {
  static Random rng = new Random();
  static const List<int> _sizeOffset = const [1, 2, 5, 2];
  static List<int> encrypt(List<int> bytes, X2e15Params params, String password) {
    Uint8List rslt = new Uint8List(bytes.length + _sizeOffset[params.protection]);
    rslt.setRange(0, bytes.length, bytes);
    List<int> pass;
    if (params.protection == X2e15Params.PROTECT_PASSWORD) {
      int salt = rng.nextInt(256);
      pass = [salt]..addAll(UTF8.encode(password));
      RC4 rc4 = new RC4(pass, 5);
      rc4.encryptBytes(rslt);
      rslt[rslt.length - 2] = salt;
    } else if (params.protection == X2e15Params.PROTECT_SALT) {
      int salt = rng.nextInt(256);
      pass = [salt, 20, 200];
      RC4 rc4 = new RC4(pass, 5);
      rc4.encryptBytes(rslt);
      rslt[rslt.length - 2] = salt;
    } else if (params.protection == X2e15Params.PROTECT_S_SALT) {
      List<int> salts = [rng.nextInt(256), rng.nextInt(256), rng.nextInt(256), rng.nextInt(256)];
      RC4 rc4 = new RC4(salts, 5);
      rc4.encryptBytes(rslt);
      rslt.setRange(bytes.length, rslt.length - 1, salts);
    }
    rslt[rslt.length - 1] = params.toByte();
    return rslt;
  }
  static List<int> decrypt(List<int> bytes, X2e15Params params, String password) {
    List<int> rslt = bytes.sublist(0, bytes.length - _sizeOffset[params.protection]);
    List<int> pass;
    if (params.protection == X2e15Params.PROTECT_PASSWORD) {
      int salt = bytes[bytes.length - 2];
      pass = [salt]..addAll(UTF8.encode(password));
      RC4 rc4 = new RC4(pass, 5);
      rc4.decryptBytes(rslt);
    } else if (params.protection == X2e15Params.PROTECT_SALT) {
      int salt = bytes[bytes.length - 2];
      pass = [salt, 20, 200];
      RC4 rc4 = new RC4(pass, 5);
      rc4.decryptBytes(rslt);
    } else if (params.protection == X2e15Params.PROTECT_S_SALT) {
      List<int> salts = bytes.sublist(bytes.length - 5, bytes.length - 1);
      RC4 rc4 = new RC4(salts, 5);
      rc4.decryptBytes(rslt);
    }
    return rslt;
  }
}
