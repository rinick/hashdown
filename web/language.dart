library language;
import 'dart:html';

Map<String, String> _lan = null;

Map<String, String> _lan_en;
Map<String, String> _lan_zh = {
  '2e15 Encoder Decoder': '2e15编解码',
  'Plain Text': '文本',
  'Encoded': '编码结果',
  'Codec:': '编码方式:',
  'Protection: ': '保护: ',
  'Raw': '无',
  '1 Byte Salt': '1字节加盐',
  '4 Bytes Salt': '4字节加盐',
  'Password: ': '密码: ',
  'Encode': '编码',
  'Decode': '解码: ',
  'TadpoleCode2': '蝌蚪解码2'
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
  if (_lan == null) return str;
  if (_lan.containsKey(str)) {
    return _lan[str];
  }
  return str;
}

void _translateElement(Element e) {
  e.text = t(e.text);
}
void _translateTitle(Element e) {
  e.title = t(e.title);
}
void _translateAll() {
  document.querySelectorAll('h1').forEach(_translateElement);
  document.querySelectorAll('h2').forEach(_translateElement);
  document.querySelectorAll('label').forEach(_translateElement);
  document.querySelectorAll('button').forEach(_translateElement);
  document.querySelectorAll('option').forEach(_translateElement);
  document.querySelectorAll('[title]').forEach(_translateTitle);
}
