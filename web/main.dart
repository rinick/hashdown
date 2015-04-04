// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import '../lib/x2e15.dart';
import 'language.dart';

InputElement opPass;
SelectElement selectCode;
SelectElement saltSelect;
Element headerh1;
void main() {
  initLanguage();
  
  querySelector('.encodeArrow').onClick.listen(onEncode);
  querySelector('.decodeArrow').onClick.listen(onDecode);
  
  opPass = querySelector('#opPass');
  opPass.onInput.listen(onPassInput);
  
  selectCode = querySelector('.selectCode>select');
  saltSelect = querySelector('#saltSelect');
  headerh1 = querySelector('h1');
  window.onResize.listen(checkSize);
  checkSize(null);
  
}
void onPassInput(Event e) {
  if (opPass.value == '') {
    saltSelect.disabled = false;
  } else {
    saltSelect.disabled = true;
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
    opt.protect = saltSelect.value;
  }
  return opt;
}

bool vmode = false;
void checkSize(Event e) {
  headerh1.style.display = window.innerWidth < 440 ? 'none':'';
  if (window.innerWidth < 480 || window.innerWidth < window.innerHeight) {
    if (!vmode) {
      
    }
  } else {
    if (vmode) {
      
    }
  }
  
}
