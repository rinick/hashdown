library x2e15.tadpolecode;
import 'dart:typed_data';

class TadpoleCode {

  static const List<int> _encodeTable = const [ //
    0x0315, 0x031B, 0x0321, 0x0322, //
    0x0327, 0x0328, 0x0334, 0x0335, //
    0x0336, 0x0337, 0x0338, 0x0358, //
    0xFE20, 0xFE21, 0xFE22, 0xFE23, //
  ];
  static final List<int> _decodeTable = (() {
    List<int> table = new List<int>(41);
    table.fillRange(0, 41, 17);
    int len = _encodeTable.length;
    for (int i = 0; i < len; ++i) {
      table[_encodeTable[i]%41] = i;
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
    out[++i] = 32;
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
      if ((code1 >= 0x0315 && code1 <= 0x0358) || (code1 >= 0xFE20 && code1 <= 0xFE23)) {
        code1 = _decodeTable[code1%41];
      }
      if((code2 >= 0x0315 && code2 <= 0x0358) || (code2 >= 0xFE20 && code2 <= 0xFE23)) {
        code2 = _decodeTable[code2%41];
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
