library hashdown.hidden_text;

import 'dart:typed_data';

class ShadowCode {
  static const int decodeTableSize = 256;

  static const List<int> _encodeTable = const [
    0x200b,
    0x200c,
    0x200d,
    0x206a,
    0x206b,
    0x206c,
    0x206d,
    0x206e,
    0x206f,
  ];

  static final List<int> _decodeTable = (() {
    List<int> table = new List<int>(decodeTableSize);
    table.fillRange(0, decodeTableSize, 9);
    int len = _encodeTable.length;
    for (int i = 0; i < len; ++i) {
      table[_encodeTable[i] % decodeTableSize] = i;
    }
    return table;
  })();

  static String encode(List<int> bytes, [List<int> extraBytes]) {
    int byte0 = -1;
    int byte1 = -1;
    if (extraBytes != null) {
      byte0 = extraBytes[0];
      byte1 = extraBytes[1];
    }
    int bg = 0; // bit got
    int bv = 0; // bit value
    int outLen = (bytes.length * 8 + 2) ~/ 3;
    if (bytes.last == byte1) {
      bytes = bytes.sublist(0, bytes.length - 1);
      outLen = (bytes.length * 8 + 3) ~/ 3; // need one more special bit
    } else {
      if (bytes.last == byte0) {
        bytes = bytes.sublist(0, bytes.length - 1);
        outLen = (bytes.length * 8 + 2) ~/ 3;
      }
      byte1 = -1;
    }
    List<int> out = new List<int>(outLen);
    int pos = 0;
    for (int byte in bytes) {
      bv = (bv & 0xFF) << 8 | byte;
      bg += 8;
      while (bg >= 3) {
        out[pos++] = _encodeTable[(bv >> (bg - 3)) & 7];
        bg -= 3;
      }
    }
    if (byte1 >= 0) {
      while (bg < 3) {
        bv = bv << 1 | 1;
        bg++;
      }
    }
    if (bg > 0) {
      out[pos++] = _encodeTable[(bv << (3 - bg)) & 7];
    }
    return new String.fromCharCodes(out);
  }

  static Uint8List decode(String input, [List<int> extraBytes]) {
    int byte0 = -1;
    int byte1 = -1;
    if (extraBytes != null) {
      byte0 = extraBytes[0];
      byte1 = extraBytes[1];
    }
    int bg = 0; // bit needed
    int bv = 0; // bit value
    int maxLen = (input.length * 3 + 7) ~/ 8;
    Uint8List out = new Uint8List(maxLen);
    int pos = 0;
    int cv;
    for (int code in input.codeUnits) {
      int cv = _decodeTable[code & 0xFF];
      if (cv >= 8) continue;
      bv = (bv & 0xFF) << 3 | cv;
      bg += 3;
      if (bg >= 8) {
        out[pos++] = (bv >> (bg - 8));
        bg -= 8;
      }
    }
    if (bg > 0 && bv.isOdd) {
      if (byte1 >= 0) {
        out[pos++] = byte1;
      }
    } else if (byte0 >= 0) {
      out[pos++] = byte0;
    }
    return out.sublist(0, pos);
  }
}
