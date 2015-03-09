// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import '../lib/x2e15.dart';
import 'language.dart';

InputElement opPass;
SelectElement selectCode;
void main() {
  initLanguage();
  
  querySelector('.encodeArrow').onClick.listen(onEncode);
  querySelector('.decodeArrow').onClick.listen(onDecode);
  
  opPass = querySelector('#opPass');
  opPass.onInput.listen(onPassInput);
  
  selectCode = querySelector('.selectCode>select');
  
}
void onPassInput(Event e) {
  if (opPass.value == '') {
    for (InputElement element in document.querySelectorAll('input[name=opProtect]')) {
      element.disabled = false;
    }
  } else {
    for (InputElement element in document.querySelectorAll('input[name=opProtect]')) {
      element.disabled = true;
    }
  }
}
void onEncode(Event e) {
  String txt = (querySelector('#inputtext') as TextAreaElement).value;
  if (txt != '') {
    (querySelector('#outputtext') as TextAreaElement).value = X2e15.encodeString(txt,getOption());
  }
}
void onDecode(Event e) {
  String txt = (querySelector('#outputtext') as TextAreaElement).value;
  if (txt != '') {
    Object obj = X2e15.decode(txt, opPass.value);
    if (obj is String) {
      (querySelector('#inputtext') as TextAreaElement).value = obj;
    }
  }
}

X2e15Options getOption(){
  X2e15Options opt = new X2e15Options();
  opt.password = opPass.value;
  opt.codec = selectCode.value;
  if (opt.password != '') {
    opt.protect = 'opPassword';
  } else {
    opt.protect = querySelector('input[name="opProtect"]:checked').id;
  }
  return opt;
}
