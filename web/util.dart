import 'dart:html';
import 'dart:js' as Js;
import 'package:hashdown/hashdown.dart';

class _AllowAllValidator implements NodeValidator {
  bool allowsAttribute(Element element, String attributeName, String value) {
    return true;
  }
  bool allowsElement(Element element) {
    return true;
  }
}

_AllowAllValidator allowAllValidator = new _AllowAllValidator();

class _MarkdownValidator implements NodeValidator {
  bool allowsAttribute(Element element, String attributeName, String value) {
    return !attributeName.startsWith('on');
  }
  bool allowsElement(Element element) {
    return (element is! ScriptElement &&
        element is! IFrameElement &&
        element is! MetaElement &&
        element is! ObjectElement &&
        element is! EmbedElement);
  }
}

_MarkdownValidator markdownValidator = new _MarkdownValidator();

RegExp _processShadowCodeReg = new RegExp(r'(\\\{|\\\}|\{|\})');
String markdownToHtml(String str, bool processShadowCode) {
  bool closeQ = false;
  String _processShadowCode(Match m) {
    switch (m.group(0)) {
      case '\\{':
        return '\\{';
      case '\\}':
        return '\\}';
      case '{':
        if (!closeQ) {
          closeQ = true;
          return '\n\n';
        }
        return '{';
      case '}':
        if (closeQ) {
          closeQ = false;
          if (m.end != m.input.length) {
            return '\n\n>';
          }
          return '\n\n';
        }
        return '}';
    }
    return '';
  }

  if (processShadowCode && str.contains(Hashdown.shadowEncodeReg)) {
    if (!str.startsWith('{')) {
      str = '>$str';
    }
    str = str.replaceAllMapped(_processShadowCodeReg, _processShadowCode);
  }
  return Js.context.callMethod('marked', [str]);
}
