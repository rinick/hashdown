///  Hashdown is free software: you can redistribute it and/or modify
///  it under the terms of the GNU General Public License as published by
///  the Free Software Foundation, either version 3 of the License, or
///  (at your option) any later version.

import '../lib/hashdown.dart';
import 'dart:js';

void main() {
  JsObject hashdown = new JsObject(context['Object']);
  hashdown['encode'] = jsEncode;
  hashdown['decode'] = jsDecode;
  hashdown['LINK'] = Hashdown.LINK;
  hashdown['BASE2E15'] = Hashdown.BASE2E15;
  hashdown['TADPOLE'] = Hashdown.TADPOLE;
  hashdown['SHADOW'] = Hashdown.SHADOW;
  hashdown['PROTECT_RAW'] = Hashdown.PROTECT_RAW;
  hashdown['PROTECT_SALT'] = Hashdown.PROTECT_SALT;
  hashdown['PROTECT_SALT4'] = Hashdown.PROTECT_SALT4;
  hashdown['PROTECT_PASSWORD'] = Hashdown.PROTECT_PASSWORD;
  
  context[r'$hashdown'] = hashdown;
}

String jsEncode(String input, [JsObject options]) {
  HashdownOptions opt = new HashdownOptions();
  if (options != null) {
    if (options.hasProperty('password')) {
      opt.password = options['password'].toString();
    }
    if (options.hasProperty('codec')) {
      opt.codec = options['codec'].toString();
    }
    if (options.hasProperty('protect')) {
      opt.protect = options['protect'].toString();
    }
    if (options.hasProperty('compress')) {
      opt.compress = options['compress'] != false;
    }
    if (options.hasProperty('markdown')) {
      opt.markdown = options['markdown'] != false;
    }
  }
  return Hashdown.encodeString(input, opt);
}
JsObject jsDecode(String input, [String password = '']) {
  HashdownResult rslt = Hashdown.decode(input, password);
  Map m = {
    'text': rslt.text,
    'useMarkdown': rslt.useMarkdown,
    'usePassword': rslt.usePassword
  };
  return new JsObject.jsify(m);
}
