// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import '../lib/x2e15.dart';
import 'language.dart';
import 'dart:async';

InputElement opPass;
SelectElement selectCode;
SelectElement saltSelect;
Element headerh1;
void main() {
  initLanguage();
  
  querySelector('.encodeArrow').onClick.listen(onEncode);
  querySelector('.decodeArrow').onClick.listen(onDecode);
  
  querySelector('.encodeV').onClick.listen(onEncodeV);
  querySelector('.decodeV').onClick.listen(onDecodeV);
  querySelector('.undoV').onClick.listen(onUndoV);
  
  opPass = querySelector('#opPass');
  opPass.onInput.listen(onPassInput);
  
  selectCode = querySelector('.selectCode>select');
  saltSelect = querySelector('#saltSelect');
  headerh1 = querySelector('h1');
  
  if (window.location.hash.indexOf('#tadpole') == 0) {
    (document.querySelector('option[value="TadpoleCode2"') as OptionElement).selected = true;
  }
  checkSize(null);
  window.onResize.listen(checkSize);
  new Timer(new Duration(milliseconds:500), initAd);
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
    if (obj == null) {
      (querySelector('#inputtext') as TextAreaElement).value = t2('Decoding failed');
    } else if (obj == '') {
      (querySelector('#inputtext') as TextAreaElement).value = t2('Wrong password');
    } else if (obj is String) {
      (querySelector('#inputtext') as TextAreaElement).value = obj;
    }
  }
}

void onEncodeV(Event e) {
  String txt = (querySelector('#vinputtext') as TextAreaElement).value;
  if (txt != '') {
    logHis(txt);
    (querySelector('#vinputtext') as TextAreaElement).value = X2e15.encodeString(txt,getOption());
    querySelector('.error').text = '';
  }
}
void onDecodeV(Event e) {
  String txt = (querySelector('#vinputtext') as TextAreaElement).value;
  if (txt != '') {
    Object obj = X2e15.decode(txt, opPass.value);
    if (obj == null) {
      querySelector('.error').text = t2('Decoding failed');
    } else if (obj == '') {
      querySelector('.error').text = t2('Wrong password');
    } else if (obj is String) {
      logHis(txt);
      (querySelector('#vinputtext') as TextAreaElement).value = obj;
      querySelector('.error').text = '';
    }
  }
}
List<String> history = [];
void logHis(String str) {
  if (str != null && str != '' && (history.length == 0 || str != history.last)) {
    history.add(str);
    if (history.length == 1) {
      (querySelector('.undoV') as ButtonElement).disabled = false;
    }
  }
}
void onUndoV(Event e) {
  if (history.length > 0) {
    (querySelector('#vinputtext') as TextAreaElement).value = history.removeLast();
    if (history.length == 0) {
      (querySelector('.undoV') as ButtonElement).disabled = true;
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
bool inited = false;
bool vmode = false;
void checkSize(Event e) {
  headerh1.style.display = window.innerWidth < 445 ? 'none':'';
  if (window.innerWidth < 480) {
    if (!vmode) {
      document.querySelector('.vbodybox').style.display = '';
      document.querySelector('.bodybox').style.display = 'none';
      vmode = true;
    }
    
  } else {
    if (vmode || !inited) {
      document.querySelector('.vbodybox').style.display = 'none';
      document.querySelector('.bodybox').style.display = '';
      vmode = false;
    }
  }
}

void initAd(){
  inited = true;
  checkSize(null);
  String host = window.location.host;
  if (host.indexOf('2e15.com') < 0) {
    return;
  }
  var aboutBox = document.querySelector('.aboutDiv');
  DivElement adDiv = document.createElement('div');
  adDiv.id = 'adDiv';
  
  NodeValidator validator = new NodeValidatorBuilder()
   ..allowHtml5()
   ..allowInlineStyles()
   ..allowElement('script', attributes: ['src','async'])
   ..allowElement('ins', attributes: ['data-ad-slot','data-ad-client']);
      
  if (window.innerWidth < 728) {
    adDiv.style.height = '100px';
    adDiv.style.left = '0';
    adDiv.style.right = '0';
    document.querySelector('.bodybox').style.bottom = '100px';
    document.querySelector('.vbodybox').style.bottom = '100px';
   
    aboutBox.style.bottom = '105px';
    aboutBox.style.right = '16px';
    adDiv.setInnerHtml(r'''
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 2e15_mobile -->
<ins class="adsbygoogle"
     style="display:inline-block;width:320px;height:100px"
     data-ad-client="ca-pub-3283235194066083"
     data-ad-slot="6644918654"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>''', validator:validator);
  } else {
    document.querySelector('.bodybox').style.bottom = '90px';
    document.querySelector('.vbodybox').style.bottom = '90px';
    document.querySelector('.downloadDiv').style.display = ''; 
    aboutBox.style.bottom = '30px';
    aboutBox.style.right = '10px';
    adDiv.setInnerHtml(r'''
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 2e15_desktop -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-3283235194066083"
     data-ad-slot="5168185454"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>''', validator:validator);
  }
  document.body.append(adDiv);
}
