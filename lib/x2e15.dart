// Copyright (c) 2015, Rick Zhou. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library base2e15.x;
import 'dart:typed_data';

part 'src/rc4.dart';

/*
 * 0,1 utf8 utf16 file bytes
 * 2 compress + 1
 * 3,4 raw, salt+1, strong salt+3, password (alawys +1 salt)
 * 5, checksum 
 * 6,7 must be 1,1
 */

class X2e15Options {
  /// 0 : utf8
  /// 1 : utf16
  /// 2 : file
  /// 3 : bytes
  int mode = 0;
  
  bool compressed = false;
  
  /// 0 : plain
  /// 1 : salt 
  /// 2 : salt (4 bytes)
  /// 3 : password
  int protection = 1;
  
  bool checksum = false;
}
// advanced,  password:
// protection: raw, salt, strong salt, password
// compression
// hashaa


/// X2e15 provide some convenient api to directly encode string or file into base2e15 format
/// support encryption and compression
class X2e15 {
  String encodeFile(X2e15File file, {String key, bool salt: true, int lineSize: 0, String padding}) {

  }
  String encodeString(String str, {String key, bool salt: true, int lineSize: 0, String padding}) {

  }
  String encodeBytes(List<int> byte, {String key, bool salt: true, int lineSize: 0, String padding}) {

  }
  /// return String, Uint8List, or X2e15File
  Object decode(String str) {

  }
}

class X2e15File {
  String name;
  Uint8List data;
  X2e15File(this.name, this.data);
}
