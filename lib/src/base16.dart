library hashdown.base16;
import 'dart:typed_data';

/// base class for TadpoleCode and HiddenText
class Base16 {

  static List<int> getDecodeTable(List<int> encodeTable) {
    List<int> table = new List<int>(256);
    table.fillRange(0, 256, 17);
    int len = encodeTable.length;
    for (int i = 0; i < len; ++i) {
      table[encodeTable[i]%256] = i;
    }
    return table;
  }
  
  static String encode(List<int> bytes, List<int> encodeTable) {
    List<int> out = new List<int> (bytes.length*2+2);
    out[0] = 47;
    int i = 0;
    for (int byte in bytes){
      out[++i] = encodeTable[byte>>4];
      out[++i] = encodeTable[byte&15];
    }
    //out[++i] = 0x200E;
    out[++i] = 0xFF9E;
    return new String.fromCharCodes(out);
  }

  static Uint8List decode(String input, List<int> decodeTable) {
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
        code1 = decodeTable[code1%256];
      }
      if (code2 >= 0x0618 && code2 <= 0x06ea) {
        code2 = decodeTable[code2%256];
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