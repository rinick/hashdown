///  Hashdown is free software: you can redistribute it and/or modify
///  it under the terms of the GNU General Public License as published by
///  the Free Software Foundation, either version 3 of the License, or
///  (at your option) any later version.

part of hashdown;

class HashdownCompress {
  static List<int> compressString(String str, HashdownParams params) {
    // don't try utf16 when it doesn't need compression
    bool tryUtf16 = (params.compressed == 1);
    List<int> utf8 = UTF8.encode(str);
    List<int> utf16;
    if (tryUtf16) {
      utf16 = UTF16.encode(str);
    }
    List<int> rslt = utf8;
    int min = utf8.length;
    params.mode = HashdownParams.MODE_UTF8;

    if (params.compressed == 1) {
      // assume compression is not needed
      params.compressed = 0;
      // don't compress short string
      if (utf8.length > 16 && utf16.length > 16) {
        if (utf16.length * 1.125 > utf8.length) {
          List<int> utf8c = compress(utf8);
          if (min > utf8c.length) {
            rslt = utf8c;
            min = utf8c.length;
            params.compressed = 1;
          }
        }
        if (utf8.length * 1.125 > utf16.length) {
          List<int> utf16c = compress(utf16);
          if (min > utf16c.length) {
            rslt = utf16c;
            min = utf16c.length;
            params.mode = HashdownParams.MODE_UTF16;
            params.compressed = 1;
          }
        }
      }
    }
    if (tryUtf16 && min > utf16.length) {
      if (params.protection == HashdownParams.PROTECT_PASSWORD) {
        // add extra 0 to validate utf16
        rslt = []
          ..addAll(utf16)
          ..add(0);
      } else {
        rslt = utf16;
      }
      params.mode = HashdownParams.MODE_UTF16;
      params.compressed = 0;
    }
    return rslt;
  }

  static List<int> compressFile(HashdownFile file, HashdownParams params) {
    List<int> data = file.encode();
    params.mode = HashdownParams.MODE_FILE;
    if (params.compressed == 1) {
      List<int> compressed = compress(data);
      if (compressed.length < data.length) {
        return compressed;
      }
    }
    params.compressed = 0;
    return data;
  }

  static Object decompressAuto(List<int> data, HashdownParams params) {
    if (params.compressed == 1) {
      data = decompress(data);
    }
    if (params.mode == HashdownParams.MODE_UTF8) {
      return UTF8.decode(data);
    }
    if (params.mode == HashdownParams.MODE_UTF16) {
      return UTF16.decode(data);
    }
    if (params.mode == HashdownParams.MODE_FILE) {
      new HashdownFile.decode(data);
    }
    return data;
  }

  static List<int> compress(List<int> data) {
    lzma_disableEndMark = true;
    List rslt = lzma_compress(data, 7);

    int len = (rslt[5]&0xFF) + ((rslt[6]&0xFF) << 8) + ((rslt[7]&0xFF) << 16) + ((rslt[8]&0xFF) << 24);
    List<int> lenArray = encodeLength(len);
    // fill the length
    for (int i = 0; i < lenArray.length; ++i) {
      rslt[13 - lenArray.length + i] = lenArray[i];
    }
    return rslt.sublist(13 - lenArray.length);
  }

  static List<int> decompress(List<int> data) {
    lzma_decodeBinary = true;
    List<int> lens = decodeLength(data);
    int len = lens[0];
    int skip = lens[1];
    List<int> fixedData = [93, 0, 0, 128, 0,
    len & 0xFF, (len >> 8) & 0xFF, (len >> 16) & 0xFF, (len >> 24) & 0xFF,
    0, 0, 0, 0
    ];
    fixedData.addAll(data.getRange(skip, data.length));
    return lzma_decompress(fixedData).map((n){return n&0xff;}).toList();;
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

  static List<int> decodeLength(List<int> input) {
    int n = 0;
    int shift = 0;
    int byte = 0xFF;
    int pos = 0;
    for (; byte > 127; ++pos) {
      byte = input[pos] & 0xFF;
      n |= (byte & 127) << shift;
      shift += 7;
    }
    return [n, pos];
  }
}
