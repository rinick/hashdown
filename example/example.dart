import 'package:hashdown/hashdown.dart';

void main() {
  // encode string to hashdown link
  String hashdownLink =
      Hashdown.encodeString('Hashdown is awesome', new HashdownOptions());
  
  // encode string to base2e15
  String base2e15 = Hashdown.encodeString(
      'Hashdown is awesome', new HashdownOptions()..codec = Hashdown.BASE2E15);
}
