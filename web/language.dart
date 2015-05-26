library language;

import 'dart:html';

Map<String, String> _lan = null;

Map<String, String> _lan_en;
Map<String, String> _lan_zh = {
  'Plain Text': '纯文本',
  'Encoded': '编码结果',
  'Markdown': '标记语言',
  'Both': '同时显示',
  'markdown.md': 'markdown.zh.md',
  'README.md': 'README.zh.md',
  'Encode Mode:': '编码模式:',
  'Salt:': '加盐:',
  'Raw': '无',
  '1 Byte': '1字节',
  '4 Bytes': '4字节',
  'Password:': '密码:',
  'Link': '链接',
  'Encode': '编码',
  'Decode': '解码',
  'Encode Markdown': '编码标记语言',
  'Undo': '撤销',
  'TadpoleCode': '蝌蚪码',
  'ShadowCode': '隐影码',
  'Help': '帮助',
  'Samples': '示例',
  'Open sample will overwrite current text': '打开示例会覆盖当前的内容',
  'edit this Hashdown': '编辑这个Hashdown',
  'create a new Hashdown': '创建新的Hashdown',
  'Decoding failed':'解码失败',
  'Wrong password':'密码错误',
  'Input text here and click the encode button':'在这里输入文字，然后点击编码按钮',
  'To decode text, paste it here and click the decode button':'需要解码时把文本粘贴到这里，然后点击解码按钮',
  'Visible text,{Hidden text}More visible text':'可见文字，{隐藏文字}更多可见文字',
  'Hosted on GitHub':'下载离线版',
  'https://github.com/rinick/hashdown':'https://github.com/rinick/hashdown/archive/gh-pages.zip',
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
  Element lanDiv = querySelector(".languageDiv");
  if (lanDiv != null)
    lanDiv.onClick.listen(toggleLanguage);
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
/// translte the string or return null
String t(String str) {
  if (_lan == null) return null;
  if (_lan.containsKey(str)) {
    return _lan[str];
  }
  return null;
}
/// translte the string or return original text
String t_(String str) {
  if (_lan == null) return str;
  if (_lan.containsKey(str)) {
    return _lan[str];
  }
  return str;
}
String getLocaleFilename(String name, String ext) {
  if (_lan == _lan_zh) {
    return '$name.zh$ext';
  } else {
    return '$name$ext';
  }
}

void _translateElement(Element e) {
  String rslt = t(e.text);
  if (rslt != null) e.text = rslt;
}
void _translateAnchor(AnchorElement e) {
  String rslt = t(e.href);
  if (rslt != null) e.href = rslt;
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
  document.querySelectorAll('.lan').forEach(_translateElement);
  document.querySelectorAll('a.a_lan').forEach(_translateAnchor);
  document.querySelectorAll('label').forEach(_translateElement);
  document.querySelectorAll('button').forEach(_translateElement);
  document.querySelectorAll('option').forEach(_translateElement);
  document.querySelectorAll('[title]').forEach(_translateTitle);
  document.querySelectorAll('textarea').forEach(_translatePlaceHolder);
}
