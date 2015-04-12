// Copyright (c) 2015, Rick Zhou. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library hashdown;
import 'dart:typed_data';
import 'dart:convert';
import 'package:base2e15/base2e15.dart';
import 'package:crypto/crypto.dart';
import "package:lzma/lzma.dart" as LZMA;
import 'dart:math';
import 'rc4.dart';
import 'tadpole.dart';

part 'src/codecs.dart';
part 'src/compress.dart';
part 'src/utf16.dart';
part 'src/crypt.dart';
/*
 * 0,1 utf8 utf16 file bytes
 * 2 reserved
 * 3,4 raw, salt+1, strong salt+3, password (alawys +1 salt)
 * 5, compress 
 * 6,7 must be 1,1
 */

class HashdownParams {
  static const int MODE_UTF8 = 0;
  static const int MODE_UTF16 = 1;
  static const int MODE_FILE = 2;
  ///reserved
  static const int MODE_BYTE = 3;

  static const int PROTECT_RAW = 0;
  static const int PROTECT_SALT = 1;
  static const int PROTECT_S_SALT = 2;
  static const int PROTECT_PASSWORD = 3;

  int mode = 0; // 2 bits
  int reserved = 0; // 1 bits
  int protection = 1; // 2 bits
  int compressed = 0; // 1 bits

  HashdownParams();
  HashdownParams.fromOption(HashdownOptions opt) {
    if ((opt.password != '' && opt.password != null) || opt.protect == 'opPassword') {
      protection = PROTECT_PASSWORD;
    } else if (opt.protect == 'opRaw') {
      protection = PROTECT_RAW;
    } else if (opt.protect == 'opSalt') {
      protection = PROTECT_SALT;
    } else if (opt.protect == 'opSSalt') {
      protection = PROTECT_S_SALT;
    }
  }
  HashdownParams.fromByte(int b) {
    mode = b & 3;
    reserved = (b >> 2) & 1;
    protection = (b >> 3) & 3;
    compressed = (b >> 5) & 1;
  }
  int toByte() {
    return 0xC0 | (compressed << 5) | (protection << 3) | (reserved << 2) | mode;
  }
}

// protection: opRaw, opSalt, opSSalt, opPassword

class HashdownOptions {
  String password;
  String protect;
  String codec;
}


/// Hashdown provide some convenient api to directly encode string or file into base2e15 format
/// support encryption and compression
class Hashdown {

  static String encodeString(String str, HashdownOptions opt) {
    HashdownParams params = new HashdownParams.fromOption(opt);
    if (params.protection == HashdownParams.PROTECT_RAW) {
      return XCodec.getCodec(opt.codec).encode(UTF8.encode(str));
    }
    List<int> data = HashdownCompress.compressString(str, params);
    data = HashdownCrypt.encrypt(data, params, opt.password);
    return XCodec.getCodec(opt.codec).encode(data);
  }
  static String encodeFile(HashdownFile file, HashdownOptions opt) {

  }

  /// return String, Uint8List, or HashdownFile
  static Object decode(String str, String password) {
    str = str.trim();
    List<int> bytes;
    HashdownParams params;
    try {
      int char0 = str.codeUnitAt(0);
      if (char0 == 47) {
        bytes = XCodec.getCodec('tadpole').decode(str);
      } else if (char0 >= 0x3400 && char0 <= 0xD7A3) {
        bytes = XCodec.getCodec('base2e15').decode(str);
      } else {
        bytes = XCodec.getCodec('link').decode(str);
      }

      if (bytes == null || bytes.length == 0) {
        return null;
      }
      if ((bytes.last & 0xC0) != 0xC0) {
        return UTF8.decode(bytes);
      }
      params = new HashdownParams.fromByte(bytes.last);
      bytes = HashdownCrypt.decrypt(bytes, params, password);
      return HashdownCompress.decompressAuto(bytes, params);
    } catch (e) {
      print(e);
      if (params != null && params.protection == HashdownParams.PROTECT_PASSWORD) {
        // blank String for password error
        return '';
      }
      // null for decode fail
      return null;
    }
  }
}

class HashdownFile {
  String name;
  List<int> data;
  HashdownFile(this.name, this.data);
  HashdownFile.decode(List<int> bytes) {
    int namelen = bytes[0];
    name = UTF8.decode(bytes.sublist(1, namelen + 1));
    data = bytes.sublist(namelen + 1);
  }
  List<int> encode() {
    List<int> namebytes = UTF8.encode(name);
    List<int> list = new List<int>(namebytes.length + 1 + data.length);
    list[0] = namebytes.length;
    list.setRange(1, namebytes.length + 1, namebytes);
    list.setRange(namebytes.length + 1, list.length, data);
    return list;
  }

}
