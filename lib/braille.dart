///  Hashdown is free software: you can redistribute it and/or modify
///  it under the terms of the GNU General Public License as published by
///  the Free Software Foundation, either version 3 of the License, or
///  (at your option) any later version.

library hashdown.braille;
import 'dart:typed_data';

class Braillnary {
  static bool _inited = false;

  static final List<int> _encodeTable = new List<int>(256);
  static final List<int> _decodeTable = new List<int>(256);

  static void _initTable(){
    if (_inited) return;
    _inited = true;

    for (int i = 0; i< 256; ++i) {
      int j = i & 0xE1;
      // move bits
      if (i&0x02 > 0) j|=0x08;
      if (i&0x04 > 0) j|=0x02;
      if (i&0x08 > 0) j|=0x10;
      if (i&0x10 > 0) j|=0x04;
      _encodeTable[i] = j | 0x2800;
      _decodeTable[j] = i;
    }
  }

  static String encode(List<int> bytes) {
    _initTable();
    List<int> out = new List<int> (bytes.length);
    int len = bytes.length;
    for (int i = 0; i < len; ++i){
      out[i] = _encodeTable[bytes[i]];

    }
    return new String.fromCharCodes(out);
  }

  static Uint8List decode(String input) {
    _initTable();
    int len = input.length;
    Uint8List out = new Uint8List(input.length);
    List codes = input.codeUnits;
    int i = 0;
    for (; i < len;++i){
      int code = codes[i]^0x2800;
      if (code > 0xFF) {
        break;
      }
      out[i] = _decodeTable[code];
    }

    return out.sublist(0, i);
  }
}
