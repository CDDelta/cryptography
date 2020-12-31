// Copyright 2019-2020 Gohilla Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:js/js_util.dart' as js;

import 'hmac.dart';
import 'javascript_bindings.dart' show jsArrayBufferFrom;
import 'javascript_bindings.dart' as web_crypto;

/// HKDF implementation that uses _Web Cryptography API_ in browsers.
///
/// See [BrowserCryptography].
class BrowserHkdf extends Hkdf {
  @override
  final BrowserHmac hmac;

  @override
  final int outputLength;

  const BrowserHkdf({required this.hmac, required this.outputLength})
      : super.constructor();

  @override
  Future<SecretKey> deriveKey({
    required SecretKey secretKey,
    required List<int> nonce,
    List<int> info = const <int>[],
  }) async {
    final jsCryptoKey = await _jsCryptoKey(secretKey);
    final byteBuffer = await js.promiseToFuture<ByteBuffer>(
      web_crypto.subtle!.deriveBits(
        web_crypto.HkdfParams(
          name: 'HKDF',
          hash: hmac.hashAlgorithmWebCryptoName,
          salt: jsArrayBufferFrom(nonce),
          info: jsArrayBufferFrom(info),
        ),
        jsCryptoKey,
        8 * outputLength,
      ),
    );
    return SecretKeyData(Uint8List.view(byteBuffer));
  }

  Future<web_crypto.CryptoKey> _jsCryptoKey(SecretKey secretKey) async {
    final secretKeyData = await secretKey.extract();
    return await js.promiseToFuture<web_crypto.CryptoKey>(
      web_crypto.subtle!.importKey(
        'raw',
        web_crypto.jsArrayBufferFrom(secretKeyData.bytes),
        'HKDF',
        false,
        const ['deriveBits'],
      ),
    );
  }
}