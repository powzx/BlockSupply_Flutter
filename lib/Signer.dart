import 'dart:convert';

import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';

class Signer {

  late PublicKey _publicKey;
  late PrivateKey _privateKey;

  Signer() {
    var curve = getSecp256k1();

    _privateKey = curve.generatePrivateKey();
    // _privateKey = PrivateKey.fromHex(curve, "73609154da7778bdc31acd460a0bf665e74d743bd592b50e2135a4caa36769c6");
    _publicKey = _privateKey.publicKey;
  }

  PrivateKey getPrivateKey() {
    return _privateKey;
  }

  PublicKey getPublicKey() {
    return _publicKey;
  }

  String sign(List<int> bytes) {
    // List<int> bytes = utf8.encode(hash);
    Signature sig = deterministicSign(_privateKey, bytes);
    
    print("R: ${sig.R.toRadixString(16)}");
    print("S: ${sig.S.toRadixString(16)}");
    
    return sig.toCompactHex();
  }
}