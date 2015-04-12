import 'dart:html';
import '../lib/hashdown.dart';
import 'language.dart';
import 'util.dart';
import 'dart:async';

String hash;
void main() {
  initLanguage();

  hash = window.location.hash;
  Object decoded = Hashdown.decode(hash, '');
  if (decoded is String) {
    if (decoded == '') {
      // password error
      querySelector('.viewerpassbox').style.display = '';
      querySelector('.decode').onClick.listen(onDecode);
    } else if (decoded.endsWith('\u001b')) {
      querySelector('.markdown').setInnerHtml(
          markdownToHtml(decoded.substring(0, decoded.length - 1)),
          validator: markdownValidator);
    } else {
      querySelector('.markdown')
        ..style.whiteSpace = 'pre-wrap'
        ..style.wordWrap = 'break-word'
        ..text = decoded;
    }
  } else {
    querySelector('.markdown').text = t2('Decoding failed');
  }
  // init edit link href
  (querySelector('#editLink') as AnchorElement).href = 'edit.html$hash';
  
  new Timer(new Duration(milliseconds: 500), initAd);
}

void onDecode(Event e) {
  Object decoded =
      Hashdown.decode(hash, (querySelector('input') as InputElement).value);
  if (decoded == '') {
    querySelector('.error').text = t2('Wrong password');
  } else if (decoded is String) {
    if (decoded.endsWith('\u001b')) {
      querySelector('.markdown').setInnerHtml(
          markdownToHtml(decoded.substring(0, decoded.length - 1)),
          validator: markdownValidator);
    } else {
      querySelector('.markdown')
        ..style.whiteSpace = 'pre-wrap'
        ..style.wordWrap = 'break-word'
        ..text = decoded;
    }
  }
}

void initAd() {
  if (!window.location.protocol.startsWith('http') ||
      document.querySelector('meta[name="hashdownad"][content="enabled"]') == null) {
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
