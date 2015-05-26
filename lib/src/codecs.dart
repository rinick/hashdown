part of hashdown;

abstract class XCodec {
  static XCodec getCodec(String name) {
    if (name.startsWith('link')) {
      return new Base64UrlCodec();
    }
    if (name.startsWith('base64')) {
      return new Base64Codec();
    }
    if (name.startsWith('tadpole')) {
      return new TadpoleCodec();
    }
    
    if (name.startsWith('shadow')) {
      return new ShadowCodeCodec();
    }
    return new Base2e15Codec();
  }
  String encode(List<int> bytes);
  List<int> decode(String str);
}

class Base2e15Codec implements XCodec {
  List<int> decode(String str) {
    return Base2e15.decode(str);
  }

  String encode(List<int> bytes) {
    return Base2e15.encode(bytes);
  }
}

class Base64Codec implements XCodec {
  List<int> decode(String str) {
    return CryptoUtils.base64StringToBytes(str);
  }

  String encode(List<int> bytes) {
    return CryptoUtils.bytesToBase64(bytes);
  }
}

class Base64UrlCodec implements XCodec {
  static String url = 'http://www.hashdown.net/#';

  List<int> decode(String str) {
    int pos = str.indexOf('#');
    if (pos > -1) {
      str = str.substring(pos + 1);
    }
    // append =
    int len = str.length;
    switch (len % 4) {
      case 3:
        str = str + '=';
        break;
      case 2:
        str = str + '==';
        break;
      case 1: // impossible
        str = str + '===';
        break;
    }
    return CryptoUtils.base64StringToBytes(str);
  }

  String encode(List<int> bytes) {
    String base64 = CryptoUtils.bytesToBase64(bytes, urlSafe: true);
    if (base64.endsWith('==')) base64 = base64.substring(0, base64.length - 2);
    else if (base64.endsWith('=')) base64 =
        base64.substring(0, base64.length - 1);
    return '$url$base64';
  }
}

class TadpoleCodec implements XCodec {
  List<int> decode(String str) {
    return TadpoleCode.decode(str);
  }

  String encode(List<int> bytes) {
    return TadpoleCode.encode(bytes);
  }
}
class ShadowCodeCodec implements XCodec {
  List<int> decode(String str) {
    return ShadowCode.decode(str, [-1, 0xC1]);
  }

  String encode(List<int> bytes) {
    return ShadowCode.encode(bytes, [0xC0, 0xC1]);
  }
}
