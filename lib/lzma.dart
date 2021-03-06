@JS('LZMA')
library LZMA;

import "package:js/js.dart";

@JS('compress')
external List<int> lzma_compress(List<int> inputs, num mode);
@JS('decompress')
external List<int> lzma_decompress(List<int> inputs);

@JS('disableEndMark')
external  set lzma_disableEndMark(bool value);

@JS('decodeBinary')
external  set lzma_decodeBinary(bool value);
