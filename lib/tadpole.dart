library hashdown.tadpolecode;
import 'dart:typed_data';

class TadpoleCode {
  static const int decodeTableSize = 256;
  
//  static int getDecodeTableSize(){
//    for (int i=256; i>0; ++i) {
//      List array = new List(i);
//      bool found = true;
//      for (var c in _encodeTable) {
//        var d = c%i;
//        if (array[d] == 1){
//          found = false;
//          break;
//        }
//        array[d] = 1;
//      }
//      if (found) {
//        return i;
//      }
//    }
//    return -1;
//  }

  static const List<int> _encodeTable = const [ //
    0x064b, 0x064c, 0x064d, 0x064e, 0x064f, //
    0x0650, 0x0651, 0x0652, 0x0653, 0x0654, 0x0655, //
    0x670, //
    0x065c,0x06e0, 0x06e4, 0x06ea//
  ];

  static final List<int> _decodeTable = (() {
    List<int> table = new List<int>(decodeTableSize);
    table.fillRange(0, decodeTableSize, 17);
    int len = _encodeTable.length;
    for (int i = 0; i < len; ++i) {
      table[_encodeTable[i]%decodeTableSize] = i;
    }
    return table;
  })();

  static String encode(List<int> bytes) {
    List<int> out = new List<int> (bytes.length*2+2);
    out[0] = 47;
    int i = 0;
    for (int byte in bytes){
      out[++i] = _encodeTable[byte>>4];
      out[++i] = _encodeTable[byte&15];
    }
    out[++i] = 0xFF9E;
    return new String.fromCharCodes(out);
  }

  static Uint8List decode(String input) {
    if (input == null || !input.startsWith('/')) {
      return null;
    }
    int len = (input.length-1)~/2;
    if (len == 0) {
      return new Uint8List(0);
    }
    Uint8List out = new Uint8List(len);
    List codes = input.codeUnits;
    int i = 0;
    for (; i < len;++i){
      int code1 = codes[(i<<1)+1];
      int code2 = codes[(i<<1)+2];
      if (code1 >= 0x0618 && code1 <= 0x06ea) {
        code1 = _decodeTable[code1%decodeTableSize];
      }
      if (code2 >= 0x0618 && code2 <= 0x06ea) {
        code2 = _decodeTable[code2%decodeTableSize];
      }
      if (code1<16 && code2<16){
        out[i] = (code1<<4) | code2;
      } else {
        break;
      }
    }
   
    return out.sublist(0, i);
  }
}
