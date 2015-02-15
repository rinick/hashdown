part of base2e15.x;

class X2e15Compress {

  static List<int> compressString(String str, X2e15Params params) {
    List<int> rslt;
    List<int> utf8 = UTF8.encode(str);
    List<int> utf8c = compress(utf8);
    List<int> uft16 = UTF16.encode(str);
    List<int> uft16c = compress(uft16);
      rslt = utf8;
      int min = utf8.length;
      params.mode = X2e15Params.MODE_UTF8;
      params.compressed = 0;
    if (min > utf8c.length) {
      rslt = utf8c;
      min = utf8c.length;
      params.compressed = 1;
    }
    if (min > uft16c.length) {
      rslt = uft16c;
      min = uft16c.length;
      params.mode = X2e15Params.MODE_UTF16;
      params.compressed = 1;
    }
    if (min > uft16.length) {
      if (params.protection == X2e15Params.PROTECT_PASSWORD){
        // add extra 0 to validate utf16
        rslt = []..addAll(uft16)..add(0);
      } else {
        rslt = uft16;
      }
      params.mode = X2e15Params.MODE_UTF16;
      params.compressed = 0;
    }
    return rslt;
  }
  static List<int> compressFile(X2e15File file, X2e15Params params) {
    List<int> data = file.encode();
    params.mode = X2e15Params.MODE_FILE;
    if (params.compressed == 1){
      List<int> compressed = compress(data);
      if (compressed.length < data.length) {
        return compressed;
      }
    }
    params.compressed = 0;
    return data;
  }
  static Object decompressAuto(List<int> data, X2e15Params params) {
    if (params.compressed == 1) {
      data = decompress(data);
    }
    if (params.mode == X2e15Params.MODE_UTF8){
      return UTF8.decode(data);
    }
    if (params.mode == X2e15Params.MODE_UTF16 ) {
      return UTF16.decode(data);
    }
    if (params.mode == X2e15Params.MODE_FILE ) {
      new X2e15File.decode(data);
    }
    return data;
  }

  static LZMA.Params _params = new LZMA.Params();
  
  static List<int> compress(List<int> data) {
    var inStream = new LZMA.InStream(data);
    var outStream = new LZMA.OutStream();
    var encoder = new LZMA.Encoder();
    encoder.setDictionarySize(1 << _params.dictionarySize);
    encoder.setNumFastBytes(_params.fb);
    encoder.setMatchFinder(_params.matchFinder);
    encoder.setLcLpPb(_params.lc, _params.lp, _params.pb);
    encoder.setEndMarkerMode(_params.eos);

    var sizes = encodeLength(data.length);
    outStream.writeBlock(sizes, 0, sizes.length);
    
    encoder.code(inStream, outStream, -1, -1);
    return outStream.data;
  }
  
  static List<int> decompress(List<int> data) {
    var inStream = new LZMA.InStream(data);
    var outStream = new LZMA.OutStream();
    var decoder = new LZMA.Decoder();
    decoder.setDecoderProperties([93, 0, 0, 128, 0]);
    
    int size = decodeLength(inStream);

    if (!decoder.decode(inStream, outStream, size)) {
      throw 'decompress failed';
    }
    return outStream.data;
  }
  static List<int> encodeLength(int n) {
    List<int> list = new List<int>();
    while (n > 127) {
      list.add((n & 127) | 128);
      n = n >> 7;
    }
    list.add(n);
    return list;
  }
  static int decodeLength(LZMA.InStream stream) {
    int n = 0;
    int shift = 0;
    int byte;
    do {
      byte = stream.read();
      n |= (byte&127) << shift;
      shift += 7;
    } while (byte > 127);
    return n;
  }
}
