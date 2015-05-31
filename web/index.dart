///  Hashdown is free software: you can redistribute it and/or modify
///  it under the terms of the GNU General Public License as published by
///  the Free Software Foundation, either version 3 of the License, or
///  (at your option) any later version.

import 'dart:html';
import 'package:hashdown/hashdown.dart';
import 'language.dart';
import 'util.dart';
import 'dart:async';

String hash;
main() async{
  initLanguage();

  hash = window.location.hash;
  String resultStr;
  try {
    if (hash.endsWith('.md')) {
      String path = hash.substring(1);
      if (!path.startsWith('http')) {
        path = getLocaleFilename(path.substring(0, path.length - 3), '.md');
      }
      resultStr = await HttpRequest.getString(path);
     } else if (hash.endsWith('.h-d')){
       String path = hash.substring(1);
       hash = await HttpRequest.getString(path);
     }
  } catch(err) {
    
  }
 
  HashdownResult result;
  if (resultStr != null) {
    // no need to decode, already load the md file
    result = new HashdownResult();
    result.params.markdown = 1;
    result.text = resultStr;
  } else {
    result = Hashdown.decode(hash, '');
  }
  
  if (result.usePassword) {
    // need password
    querySelector('.viewerpassbox').style.display = '';
    querySelector('.decode').onClick.listen(onDecode);
  }else if (result.text != null) {
    if (result.useMarkdown) {
      querySelector('.markdown').setInnerHtml(
          markdownToHtml(result.text, false),
          validator: markdownValidator);
    } else {
      querySelector('.markdown')
        ..style.whiteSpace = 'pre-wrap'
        ..style.wordWrap = 'break-word'
        ..text = result.text;
    }
  } else {
    querySelector('.markdown').text = t_('Decoding failed');
  }
  // init edit link href
  (querySelector('#editLink') as AnchorElement).href = 'edit.html$hash';
  
  new Timer(new Duration(milliseconds: 500), initAd);
}

void onDecode(Event e) {
  HashdownResult result = 
      Hashdown.decode(hash, (querySelector('input') as InputElement).value);
  if (result.text == null) {
    if (result.usePassword) {
      querySelector('.error').text = t_('Wrong password');
    }
  } else {
    if (result.useMarkdown) {
      querySelector('.markdown').setInnerHtml(
          markdownToHtml(result.text, false),
          validator: markdownValidator);
    } else {
      querySelector('.markdown')
        ..style.whiteSpace = 'pre-wrap'
        ..style.wordWrap = 'break-word'
        ..text = result.text;
    }
  }
}

void initAd() {
  if (!window.location.protocol.startsWith('http') ||
      document.querySelector('meta[name=hashdownad][content=enabled]') == null) {
    return;
  }
  var aboutBox = document.querySelector('.aboutDiv');
  DivElement adDiv = document.createElement('div');

    adDiv.style.height = '100px';
    adDiv.setInnerHtml(r'''
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 2e15_mobile -->
<ins class="adsbygoogle"
     style="display:inline-block;width:320px;height:100px"
     data-ad-client="ca-pub-3283235194066083"
     data-ad-slot="6644918654"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>''', validator: allowAllValidator);

  document.querySelector('.viewerbox').append(adDiv);
}
