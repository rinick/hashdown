// Copyright (c) 2015, Rick Zhou. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of base2e15.x;

class RC4 {
  int i = 0,
      j = 0;
  List<int> S;
  RC4(List<int> key, [int round = 1]) {
    S = new List<int>(256);
    for (int x = 0; x < 256; ++x) {
      S[x] = x;
    }
    int keylen = key.length;
    for (int r = 0; r < round; ++r) {
      int j = 0;
      for (int i = 0; i < 256; ++i) {
        int keyv = key[i % keylen];
        j = (j + S[i] + keyv) & 0xFF;
        int t = S[i];
        S[i] = S[j];
        S[j] = t;
      }
    }
    i = j = 0;
  }
  /// standard RC4 bytes
  void xorBytes(List<int> bytes) {
    int t, len = bytes.length;
    for (int x = 0; x < len; ++x) {
      i = (i + 1) & 0xFF;
      j = (j + S[i]) & 0xFF;
      t = S[i];
      S[i] = S[j];
      S[j] = t;
      bytes[x] ^= S[(S[i] + S[j]) & 0xFF];
    }
  }
  /// custom encryption
  void encryptBytes(List<int> bytes) {
    int t, len = bytes.length;
    for (int x = 0; x < len; ++x) {
      i = (i + 1) & 0xFF;
      j = (j + S[i]) & 0xFF;
      t = S[i];
      S[i] = S[j];
      S[j] = t;
      bytes[x] ^= S[(S[i] + S[j]) & 0xFF];
      j = (j + bytes[x]) & 0xFF;
    }
  }
  /// custom decryption
  void decryptBytes(List<int> bytes) {
    int t, len = bytes.length;
    for (int x = 0; x < len; ++x) {
      i = (i + 1) & 0xFF;
      j = (j + S[i]) & 0xFF;
      t = S[i];
      S[i] = S[j];
      S[j] = t;
      int byte = bytes[x];
      bytes[x] ^= S[(S[i] + S[j]) & 0xFF];
      j = (j + byte) & 0xFF;
    }
  }
}
