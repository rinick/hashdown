///  Hashdown is free software: you can redistribute it and/or modify
///  it under the terms of the GNU General Public License as published by
///  the Free Software Foundation, either version 3 of the License, or
///  (at your option) any later version.

part of hashdown;

class UTF16 {
  static Uint8List encode(String str) {
    Uint8List out = new Uint8List(str.length * 2);
    int i = 0;
    List<int> codes = str.codeUnits;
    for (int byte in codes) {
      out[i++] = byte >> 8;
      out[i++] = byte & 255;
    }
    return out;
  }

  static String decode(List<int> bytes) {
    if (bytes.length % 2 == 1 && bytes.last != 0) {
      // if there is an extra byte, it must be 0
      throw 'invalid utf16';
    }
    int len = bytes.length >> 1;
    List<int> out = new List<int>(len);
    int i = 0;
//    bool waiting = false;
    for ( ; i < len; ++i) {
      int code1 = bytes[(i << 1)];
      int code2 = bytes[(i << 1)+1];
      int c = (code1 << 8) | code2;
      out[i] = c;
//      if (c >=0xD800 && c < 0xE000){
//        if ((c < 0xDC00) != waiting){
//          waiting = !waiting;
//        } else {
//          throw 'invalid utf16';
//        }
//      }
    }
//    if (waiting) {
//      throw 'invalid utf16';
//    }
    return new String.fromCharCodes(out);
  }
}
