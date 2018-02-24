///  Hashdown is free software: you can redistribute it and/or modify
///  it under the terms of the GNU General Public License as published by
///  the Free Software Foundation, either version 3 of the License, or
///  (at your option) any later version.

library hashdown.braille;
import 'dart:typed_data';

class Braillnary {

  static String encode(List<int> bytes) {
    List<int> out = new List<int> (bytes.length);
    int len = bytes.length;
    for (int i = 0; i < len; ++i){
      out[i] = bytes[i] | 0x2800;

    }
    return new String.fromCharCodes(out);
  }

  static Uint8List decode(String input) {
    int len = input.length;
    Uint8List out = new Uint8List(input.length);
    List codes = input.codeUnits;
    int i = 0;
    for (; i < len;++i){
      int code = codes[i]^0x2800;
      if (code > 0xFF) {
        break;
      }
      out[i] = code;
    }

    return out.sublist(0, i);
  }
}
