part of base2e15.x;

abstract class XCodec {
  static XCodec getCodec(String name) {
    if (name.toLowerCase().startsWith('base64')) {
      return new Base64Codec();
    }
    if (name.toLowerCase().startsWith('tadpole')) {
      return new TadpoleCodec();
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

class TadpoleCodec implements XCodec {

  List<int> decode(String str) {
    return Tadoole2.decode(str);
  }

  String encode(List<int> bytes) {
    return Tadoole2.encode(bytes);
  }
}
