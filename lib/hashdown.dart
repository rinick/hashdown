///  Hashdown is free software: you can redistribute it and/or modify
///  it under the terms of the GNU General Public License as published by
///  the Free Software Foundation, either version 3 of the License, or
///  (at your option) any later version.

library hashdown;
import 'dart:typed_data';
import 'dart:convert';
import 'package:base2e15/base2e15.dart';
import 'package:crypto/crypto.dart';
import "package:lzma/lzma.dart" as LZMA;
import 'dart:math';
import 'rc4.dart';
import 'tadpole.dart';
import 'shadow.dart';

part 'src/codecs.dart';
part 'src/compress.dart';
part 'src/utf16.dart';
part 'src/crypt.dart';
/*
 * 0,1 utf8 utf16 file reservedMode
 * 2 markdown
 * 3,4 raw, salt+1, strong salt+3, password (alawys +1 salt)
 * 5, compress 
 * 6,7 must be 1,1
 */

class HashdownParams {
  static final defaultParams = new HashdownParams();
  static const int MODE_UTF8 = 0;
  static const int MODE_UTF16 = 1;
  static const int MODE_FILE = 2;
 

  static const int PROTECT_RAW = 0;
  static const int PROTECT_SALT = 1;
  static const int PROTECT_SALT4 = 2;
  static const int PROTECT_PASSWORD = 3;

  int mode = 0; // 2 bits
  int markdown = 0; // 1 bits
  int protection = 1; // 2 bits
  int compressed = 0; // 1 bits
  
  HashdownParams();
  HashdownParams.fromOption(HashdownOptions opt) {
    if ((opt.password != '' && opt.password != null) || opt.protect == Hashdown.PROTECT_PASSWORD) {
      protection = PROTECT_PASSWORD;
    } else if (opt.protect == Hashdown.PROTECT_RAW) {
      protection = PROTECT_RAW;
    } else if (opt.protect == Hashdown.PROTECT_SALT) {
      protection = PROTECT_SALT;
    } else if (opt.protect == Hashdown.PROTECT_SALT4) {
      protection = PROTECT_SALT4;
    }
    if (opt.markdown) {
      markdown = 1;
    }
    if (opt.compress) {
      compressed = 1;
    }
  }
  HashdownParams.fromByte(int b) {
    if (b & 0xC0 == 0xC0) {
      mode = b & 3;
      markdown = (b >> 2) & 1;
      protection = (b >> 3) & 3;
      compressed = (b >> 5) & 1;
    } else {
      mode = MODE_UTF8;
      markdown = 0;
      protection = PROTECT_RAW;
      compressed = 0;
    }
  }
  int toByte() {
    return 0xC0 | (compressed << 5) | (protection << 3) | (markdown << 2) | mode;
  }
}

class HashdownOptions {
  String password = '';
  /// protect mode 
  String protect = Hashdown.PROTECT_SALT;
  /// encode mode
  String codec = Hashdown.LINK;
  /// encode/decode as markdown
  bool markdown = false;
  /// use compression
  bool compress = true;
}

class HashdownResult {
  String codec;
  HashdownParams params = HashdownParams.defaultParams;
  String text;
  HashdownFile file;
  
  bool get useMarkdown => params.markdown == 1;
  bool get useCompression => params.compressed == 1;
  bool get isString => params.mode == HashdownParams.MODE_UTF8 || params.mode == HashdownParams.MODE_UTF16;
  bool get isFile => params.mode == HashdownParams.MODE_FILE;
  bool get usePassword => params.protection == HashdownParams.PROTECT_PASSWORD;
}

/// Hashdown provide some convenient api to directly encode string or file into base2e15/tadpoleCode/link format
/// It also supports encryption and compression
class Hashdown {
  static const String LINK = 'link';
  static const String TADPOLE = 'tadpole';
  static const String BASE2E15 = 'base2e15';
  static const String SHADOW = 'shadow';
  
  static const String PROTECT_RAW = 'raw';
  static const String PROTECT_SALT = 'salt';
  static const String PROTECT_SALT4 = 'salt4';
  static const String PROTECT_PASSWORD = 'password';
  
  
  static String encodeString(String str, HashdownOptions opt) {
    if (opt.codec == SHADOW && str.contains(shadowEncodeReg)) {
      return _encodeShadowCode(str, opt);
    }
    HashdownParams params = new HashdownParams.fromOption(opt);
    List<int> data = HashdownCompress.compressString(str, params);
    data = HashdownCrypt.encrypt(data, params, opt.password);
    return XCodec.getCodec(opt.codec).encode(data);
  }
  static final RegExp shadowEncodeReg = new RegExp(r'(^|[^\\])\{[^\u0000]*?[^\\]\}');
  static String _encodeShadowCode(String str, HashdownOptions opt) {
    String replaceShadowCode(Match m) {
      String str = m.group(0);
      String firstChar;
      if (str.startsWith('{')){
        firstChar = '';
        str = str.substring(1, str.length - 1);
      } else {
        firstChar = str.substring(0,1);
        str = str.substring(2, str.length - 1);
      }
      str = str.replaceAll('\\{', '{').replaceAll('\\}', '}');
      HashdownParams params = new HashdownParams.fromOption(opt);
      List<int> data = HashdownCompress.compressString(str, params);
      data = HashdownCrypt.encrypt(data, params, opt.password);
      return '$firstChar${XCodec.getCodec(SHADOW).encode(data)}';
    }
    return str.replaceAllMapped(shadowEncodeReg, replaceShadowCode).replaceAll('\\{', '{').replaceAll('\\}', '}');
  }
  static String encodeFile(HashdownFile file, HashdownOptions opt) {
    HashdownParams params = new HashdownParams.fromOption(opt);
    List<int> data = HashdownCompress.compressFile(file, params);
    data = HashdownCrypt.encrypt(data, params, opt.password);
    return XCodec.getCodec(opt.codec).encode(data);
  }

  static final RegExp _tadpoleReg = new RegExp(r'\/[\u0600-\u06ff]{2,}');
  static final RegExp _shadowReg = new RegExp(r'[\u200b-\u206f]{3,}');
  
  /// return String, Uint8List, or HashdownFile
  static HashdownResult decode(String str, [String password = '']) {
    str = str.trim();
    List<int> bytes;
    HashdownResult result = new HashdownResult();
    HashdownParams params;
    bool checkPartialShadowCode = false;
    try {
      Match m1 = _shadowReg.firstMatch(str);
      if (m1 != null) {
        if (m1.group(0) != str) {
          checkPartialShadowCode = true;
        }
        bytes = XCodec.getCodec(SHADOW).decode(m1.group(0));
        result.codec = SHADOW;
      } else {
        Match m2 = _tadpoleReg.firstMatch(str);
        if (m2 != null) {
          bytes = XCodec.getCodec(TADPOLE).decode(m2.group(0));
          result.codec = TADPOLE;
        } else {
          int char0 = str.codeUnitAt(0);
          if (char0 >= 0x3400 && char0 <= 0xD7A3) {
            bytes = XCodec.getCodec(BASE2E15).decode(str);
            result.codec = BASE2E15;
          } else {
            bytes = XCodec.getCodec(LINK).decode(str);
            result.codec = LINK;
          }
        }
      }

      if (bytes == null || bytes.length == 0) {
        return result;
      }
      
      params = new HashdownParams.fromByte(bytes.last);
      if (checkPartialShadowCode && params.mode != HashdownParams.MODE_FILE) {
        return _decodeShadowCodes(str, password);
      }
      result.params = params;
      if (result.usePassword && (password == '' || password == null)) {
        return result;
      }
      if ((bytes.last & 0xC0) != 0xC0) {
        result.text = UTF8.decode(bytes);
        return result;
      }
      
      bytes = HashdownCrypt.decrypt(bytes, params, password);
      Object data =  HashdownCompress.decompressAuto(bytes, params);
      if (data is String) {
        result.text = data;
      } else if (data is HashdownFile) {
        result.file = data;
      }
    } catch (e) {
      //print(e);
    }
    return result;
  }
  static HashdownResult _decodeShadowCodes(String str, [String password = '']) {
    str = str.replaceAll('{', '\\{').replaceAll('}', '\\}');
    HashdownResult result = new HashdownResult();
    result.codec = SHADOW;
    bool getParam = true;
    String decodeShadowCode(Match m) {
      try {
        List<int> bytes = XCodec.getCodec(SHADOW).decode(m.group(0));
        if (bytes == null || bytes.length == 0) {
          return '';
        }
        HashdownParams params = new HashdownParams.fromByte(bytes.last);
        if (getParam) {
          result.params = params;
          getParam = false;
        }
        
        if (result.usePassword && (password == '' || password == null)) {
          return '';
        }
        if ((bytes.last & 0xC0) != 0xC0) {
          return '{${UTF8.decode(bytes)}}';
        }
        
        bytes = HashdownCrypt.decrypt(bytes, params, password);
        Object data =  HashdownCompress.decompressAuto(bytes, params);
        if (data is String) {
          return '{${data.replaceAll("}","\\}").replaceAll("{","\\{")}}';
        } else if (data is HashdownFile) {
          result.file = data;
        }
      } catch (err) {
      }
      return '';
    }
    result.text = str.replaceAllMapped(_shadowReg, decodeShadowCode);
    return result;
  }
}

class HashdownFile {
  String name;
  List<int> data;
  HashdownFile(this.name, this.data) {
    if (name.length>256) {
      name = name.substring(0, 256);
    }
  }
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
