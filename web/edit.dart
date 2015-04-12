// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import '../lib/hashdown.dart';
import 'language.dart';
import 'util.dart';
import 'dart:async';
import 'dart:math';

InputElement opPass;

SelectElement selectCode;
SelectElement saltSelect;
LabelElement saltSelectLabel;
Element headerh1;

String pendingInitData;

TextAreaElement inputtext;
TextAreaElement outputtext;
TextAreaElement vinputtext;

Element encodedTab;
void main() {
  Base64UrlCodec.url = window.location
      .toString()
      .replaceFirst(new RegExp(r'\/edit\.html.*'), '/#');

  initLanguage();

  querySelector('.encodeArrow').onClick.listen(onEncode);
  querySelector('.decodeArrow').onClick.listen(onDecode);
  querySelector('.markdownBtn').onClick.listen(onMarkdown);

  querySelector('.encodeV').onClick.listen(onEncodeV);
  querySelector('.decodeV').onClick.listen(onDecodeV);
  querySelector('.markdownVBtn').onClick.listen(onMarkdownV);
  querySelector('.undoV').onClick.listen(onUndoV);

  inputtext = querySelector('#inputtext');
  outputtext = querySelector('#outputtext');
  vinputtext = querySelector('#vinputtext');

  encodedTab = querySelector('#encodedTab');

  opPass = querySelector('#opPass');
  opPass.onInput.listen(onPassInput);

  selectCode = querySelector('.selectCode>select');
  saltSelect = querySelector('#saltSelect');
  saltSelectLabel = querySelector('#saltSelectLabel');
  headerh1 = querySelector('h1');

  encodedTab.onClick.listen(onClickLink);

  checkSize(null);
  window.onResize.listen(checkSize);
  new Timer(new Duration(milliseconds: 500), initAd);

  String hash = window.location.hash;
  if (hash.length > 1) {
    if (hash == '#help') {
      HttpRequest.getString(t2('markdown.md')).then((String str) {
        inputtext.value = str;
        if (!markdown) {
          onMarkdown(null);
        }
      });
    } else if (hash.length < 10) {
      Element opt =
          document.querySelector('option[value="${hash.substring(1)}"');
      if (opt is OptionElement) {
        opt.selected = true;
      }
    } else {
      pendingInitData = Base64UrlCodec.url + hash.substring(1);
    }
  } else if (Base64UrlCodec.url.indexOf('2e15.com') > 0) {
    (document.querySelector('option[value="base2e15"') as OptionElement).selected = true;
  }
  selectCode.onChange.listen((e) {
    window.location.hash = '#${selectCode.value}';
  });
}
void onPassInput(Event e) {
  if (opPass.value == '') {
    saltSelect.disabled = false;
    saltSelectLabel.classes.remove('disabled');
  } else {
    saltSelect.disabled = true;
    saltSelectLabel.classes.add('disabled');
  }
}

bool markdown = false;

void onMarkdown(Event e) {
  if (markdown) {
    markdown = false;
    querySelector('.markdownbox').style.display = 'none';
    querySelector('.encodeMarkdown').style.display = 'none';
    querySelector('#markdown').innerHtml = '';
    querySelector('.markdownBtn').classes.remove('blue');
    if (inputChangeListener != null) {
      inputChangeListener.cancel();
      inputChangeListener = null;
    }
  } else {
    markdown = true;
    querySelector('.markdownbox').style.display = '';
    querySelector('.encodeMarkdown').style.display = '';
    querySelector('#markdown').setInnerHtml(markdownToHtml(inputtext.value),
        validator: markdownValidator);
    querySelector('.markdownBtn').classes.add('blue');
    if (inputChangeListener == null) {
      inputChangeListener = inputtext.onInput.listen(onMarkdownUpdate);
    }
  }
}
StreamSubscription inputChangeListener;
Timer updateMarkdownTimer;
void onMarkdownUpdate(Event e) {
  if (updateMarkdownTimer != null) {
    updateMarkdownTimer.cancel();
  }
  updateMarkdownTimer =
      new Timer(new Duration(milliseconds: 300), doMarkdownUpdate);
}
void doMarkdownUpdate() {
  updateMarkdownTimer = null;
  if (inputChangeListener == null) return;
  querySelector('#markdown').setInnerHtml(markdownToHtml(inputtext.value),
      validator: markdownValidator);
}

void onEncode(Event e) {
  String txt = inputtext.value;
  if (txt != '') {
    if (markdown) {
      txt = '$txt\u001b';
    }
    HashdownOptions option = getOption();
    outputtext.value = Hashdown.encodeString(txt, option);
    if (option.codec == 'link') {
      setLink(outputtext.value);
    } else {
      setLink(null);
    }
  }
}
void onDecode(Event e) {
  String txt = outputtext.value;
  if (txt != '') {
    Object obj = Hashdown.decode(txt, opPass.value);
    if (obj == null) {
      inputtext.value = t2('Decoding failed');
    } else if (obj == '') {
      inputtext.value = t2('Wrong password');
    } else if (obj is String) {
      if (obj.endsWith('\u001b')) {
        //markdown
        inputtext.value = obj.substring(0, obj.length - 1);
        markdown = false; // force a conversion
        onMarkdown(null);
      } else {
        inputtext.value = obj;
      }
    }
  }
}

String link;
void setLink(String str) {
  link = str;
  if (link != null) {
    encodedTab.classes.add('linkbtn');
  } else {
    encodedTab.classes.remove('linkbtn');
  }
}

void onClickLink(Event e) {
  if (link != null) {
    window.open(link, '_blank');
  }
}

void onEncodeV(Event e) {
  String txt = vinputtext.value;
  if (txt != '') {
    logHis(txt);
    if (markdownV) {
      txt = '$txt\u001b';
      onMarkdownV(null);
    }
    vinputtext.value = Hashdown.encodeString(txt, getOption());
    querySelector('.error').text = '';
  }
}
void onDecodeV(Event e) {
  String txt = vinputtext.value;
  if (txt != '') {
    Object obj = Hashdown.decode(txt, opPass.value);
    if (obj == null) {
      querySelector('.error').text = t2('Decoding failed');
    } else if (obj == '') {
      querySelector('.error').text = t2('Wrong password');
    } else if (obj is String) {
      String rslt = obj;
      logHis(txt);
      if (rslt.endsWith('\u001b')) {
        //markdown
        rslt = rslt.substring(0, rslt.length - 1);
        vinputtext.value = rslt;
        markdownV = false; // force a conversion
        onMarkdownV(null);
      } else {
        vinputtext.value = rslt;
      }
      querySelector('.error').text = '';
    }
  }
}
List<String> history = [];
void logHis(String str) {
  if (str != null &&
      str != '' &&
      (history.length == 0 || str != history.last)) {
    history.add(str);
    if (history.length == 1) {
      (querySelector('.undoV') as ButtonElement).disabled = false;
    }
  }
}

bool markdownV = false;
void onMarkdownV(Event e) {
  if (markdownV) {
    markdownV = false;
    querySelector('#vmarkdown')
      ..style.display = 'none'
      ..innerHtml = '';
    querySelector('.markdownVBtn').classes.remove('blue');
    querySelector('.encodeV').text = t2('Encode');
    querySelector('.decodeV').style.display = '';
  } else {
    markdownV = true;
    querySelector('#vmarkdown')
      ..style.display = ''
      ..setInnerHtml(markdownToHtml(vinputtext.value),
          validator: markdownValidator);
    querySelector('.markdownVBtn').classes.add('blue');
    querySelector('.encodeV').text = t2('Encode Markdown');
    querySelector('.decodeV').style.display = 'none';
  }
}
void onUndoV(Event e) {
  if (history.length > 0) {
    vinputtext.value = history.removeLast();
    if (history.length == 0) {
      (querySelector('.undoV') as ButtonElement).disabled = true;
    }
    if (markdownV) {
      onMarkdownV(null);
    }
  }
}

HashdownOptions getOption() {
  HashdownOptions opt = new HashdownOptions();
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
  headerh1.style.display = window.innerWidth < 445 ? 'none' : '';
  if (window.innerWidth < 480) {
    if (pendingInitData != null) {
      vinputtext.value = pendingInitData;
      onDecodeV(null);
      pendingInitData = null;
    }
    if (!vmode) {
      document.querySelector('.vbodybox').style.display = '';
      document.querySelector('.bodybox').style.display = 'none';
      vmode = true;
    }
  } else {
    if (pendingInitData != null) {
      outputtext.value = pendingInitData;
      onDecode(null);
      pendingInitData = null;
    }
    if (vmode || !inited) {
      document.querySelector('.vbodybox').style.display = 'none';
      document.querySelector('.bodybox').style.display = '';
      vmode = false;
    }
  }
}

void initAd() {
  inited = true;
  checkSize(null);
  if (!window.location.protocol.startsWith('http') ||
      document.querySelector('meta[name="hashdownad"][content="enabled"]') ==
          null) {
    return;
  }
  var aboutBox = document.querySelector('.aboutDiv');
  DivElement adDiv = document.createElement('div');
  adDiv.id = 'adDiv';

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
     style="display:inline-block;width:320px;height:100px;margin:auto;"
     data-ad-client="ca-pub-3283235194066083"
     data-ad-slot="6644918654"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>''', validator: allowAllValidator);
  } else {
    adDiv.style.height = '90px';
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
</script>''', validator: allowAllValidator);
  }
  document.querySelector('.sizebox').append(adDiv);
}
