///  Hashdown is free software: you can redistribute it and/or modify
///  it under the terms of the GNU General Public License as published by
///  the Free Software Foundation, either version 3 of the License, or
///  (at your option) any later version.

part of hashdown;

class HashdownCrypt {
  static Random rng = new Random();
  static const List<int> _sizeOffset = const [1, 2, 5, 2];
  static List<int> encrypt(List<int> bytes, HashdownParams params, String password) {
    int tail = params.toByte();
    if (tail == 0xC0) {
      return bytes;
    }

    Uint8List rslt = new Uint8List(bytes.length + _sizeOffset[params.protection]);
    rslt.setRange(0, bytes.length, bytes);
    List<int> pass;
    if (params.protection == HashdownParams.PROTECT_PASSWORD) {
      // only 7 bits salt, reserve 1 bits for other purpose (like pk encryption)
      int salt = rng.nextInt(64);
      pass = [salt]..addAll(utf8.encode(password));
      RC4 rc4 = new RC4(pass, 5);
      rc4.encryptBytes(rslt);
      rslt[rslt.length - 2] = salt;
    } else if (params.protection == HashdownParams.PROTECT_SALT) {
      int salt = rng.nextInt(256);
      pass = [salt, 20, 200];
      RC4 rc4 = new RC4(pass, 5);
      rc4.encryptBytes(rslt);
      rslt[rslt.length - 2] = salt;
    } else if (params.protection == HashdownParams.PROTECT_SALT4) {
      List<int> salts = [rng.nextInt(256), rng.nextInt(256), rng.nextInt(256), rng.nextInt(256)];
      RC4 rc4 = new RC4(salts, 5);
      rc4.encryptBytes(rslt);
      rslt.setRange(bytes.length, rslt.length - 1, salts);
    }

    rslt[rslt.length - 1] = tail;

    return rslt;
  }
  static List<int> decrypt(List<int> bytes, HashdownParams params, String password) {
    List<int> rslt = bytes.sublist(0, bytes.length - _sizeOffset[params.protection]);
    List<int> pass;
    if (params.protection == HashdownParams.PROTECT_PASSWORD) {
      int salt = bytes[bytes.length - 2];
      pass = [salt]..addAll(utf8.encode(password));
      RC4 rc4 = new RC4(pass, 5);
      rc4.decryptBytes(rslt);
    } else if (params.protection == HashdownParams.PROTECT_SALT) {
      int salt = bytes[bytes.length - 2];
      pass = [salt, 20, 200];
      RC4 rc4 = new RC4(pass, 5);
      rc4.decryptBytes(rslt);
    } else if (params.protection == HashdownParams.PROTECT_SALT4) {
      List<int> salts = bytes.sublist(bytes.length - 5, bytes.length - 1);
      RC4 rc4 = new RC4(salts, 5);
      rc4.decryptBytes(rslt);
    }
    return rslt;
  }
}
