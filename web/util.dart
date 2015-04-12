import 'dart:html';
import 'dart:js' as Js;

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
    return  (element is! ScriptElement && element is! IFrameElement && element is! MetaElement && element is! ObjectElement && element is!EmbedElement);
  }
}

_MarkdownValidator markdownValidator = new _MarkdownValidator();


String markdownToHtml(String str){
  return Js.context.callMethod('marked', [str]);
}