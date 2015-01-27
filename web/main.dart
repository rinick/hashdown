// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:base2e15/base2e15.dart';
import 'dart:convert';

void main() {
  querySelector('.encodeArrow').onClick.listen(onEncode);
  querySelector('.decodeArrow').onClick.listen(onDecode);
}
void onEncode(Event e) {
  String txt = (querySelector('#inputtext') as TextAreaElement).value;
  if (txt != '') {
    (querySelector('#outputtext') as TextAreaElement).value = Base2e15.encode(UTF8.encode(txt));
  }
}
void onDecode(Event e) {
  String txt = (querySelector('#outputtext') as TextAreaElement).value;
  if (txt != '') {
    var bytes = Base2e15.decode(txt);
    try {
      String str = UTF8.decode(bytes);
      if (str != '') {
        (querySelector('#inputtext') as TextAreaElement).value = str;
      }
    } catch (err) {

    }
  }
}
