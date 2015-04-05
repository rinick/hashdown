library language;

import 'dart:html';

Map<String, String> _lan = null;

Map<String, String> _lan_en;
Map<String, String> _lan_zh = {
  '2e15 Encoder': '2e15编码',
  'Plain Text': '文本',
  'Encoded': '编码结果',
  'Codec:': '编码方式:',
  'Salt:': '加盐:',
  'Raw': '无',
  '1 Byte': '1字节',
  '4 Bytes': '4字节',
  'Password:': '密码:',
  'Encode': '编码',
  'Decode': '解码',
  'Undo': '撤销',
  'TadpoleCode2': '蝌蚪解码2',
  'Decoding failed':'解码失败',
  'Wrong password':'密码错误',
  'Download Offline Version':'下载离线版',
  'Input text here and click the encode button':'在这里输入文字后点击编码按钮',
  'To decode text, paste it here and click the decode button':'需要解码时把文本粘贴到这里，然后点击解码按钮'
};

Element cnflag;
Element usflag;
void initLanguage() {
  cnflag = querySelector('#cnflag');
  usflag = querySelector('#usflag');

  if (window.localStorage['lan'] == 'zh') {
    _lan = _lan_zh;
    usflag.classes.remove('currentLan');
    cnflag.classes.add('currentLan');
    _translateAll();
  } else if (window.localStorage['lan'] == 'en') {
  } else if (window.navigator.language.startsWith('zh')) {
    _lan = _lan_zh;
    usflag.classes.remove('currentLan');
    cnflag.classes.add('currentLan');
    _translateAll();
  }
  querySelector(".languageDiv").onClick.listen(toggleLanguage);
}

void toggleLanguage(MouseEvent e) {
  if (_lan == _lan_zh) {
    if (_lan_en == null) {
      _lan_en = {};
      _lan_zh.forEach((key, val) {
        _lan_en[val] = key;
      });
    }
    _lan = _lan_en;
    window.localStorage['lan'] = 'en';
    cnflag.classes.remove('currentLan');
    usflag.classes.add('currentLan');
  } else {
    _lan = _lan_zh;
    window.localStorage['lan'] = 'zh';
    usflag.classes.remove('currentLan');
    cnflag.classes.add('currentLan');
  }
  _translateAll();
}

String t(String str) {
  if (_lan == null) return null;
  if (_lan.containsKey(str)) {
    return _lan[str];
  }
  return null;
}
String t2(String str) {
  if (_lan == null) return str;
  if (_lan.containsKey(str)) {
    return _lan[str];
  }
  return str;
}
void _translateElement(Element e) {
  String rslt = t(e.text);
  if (rslt != null) e.text = rslt;
}
void _translateTitle(Element e) {
  String rslt = t(e.title);
  if (rslt != null) e.title = rslt;
}
void _translatePlaceHolder(TextAreaElement e) {
  String rslt = t(e.placeholder);
  if (rslt != null) e.placeholder = rslt;
}

void _translateAll() {
  document.querySelectorAll('h1').forEach(_translateElement);
  document.querySelectorAll('h2').forEach(_translateElement);
  document.querySelectorAll('label').forEach(_translateElement);
  document.querySelectorAll('button').forEach(_translateElement);
  document.querySelectorAll('option').forEach(_translateElement);
  document.querySelectorAll('[title]').forEach(_translateTitle);
  document.querySelectorAll('textarea').forEach(_translatePlaceHolder);
}
