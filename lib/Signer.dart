import 'package:blocksupply_flutter/storage_service.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';

class Signer {
  PublicKey _publicKey;
  PrivateKey _privateKey;
  bool hasSetUp;

  final StorageService _storageService = new StorageService();

  Signer() {
    var curve = getSecp256k1();

    _privateKey = curve.generatePrivateKey();
    _publicKey = _privateKey.publicKey;

    hasSetUp = false;

    print('Created new public key: ${this.getPublicKeyHex()}');
  }

  Signer.fromExisting(String privateKey) {
    var curve = getSecp256k1();

    _privateKey = PrivateKey.fromHex(curve, privateKey);
    _publicKey = _privateKey.publicKey;

    hasSetUp = true;

    print('Found public key: ${this.getPublicKeyHex()}');
  }

  void writeToSecureStorage() {
    _storageService.writeSecureData(
        new StorageItem('blockchain_private_key', _privateKey.toHex()));
  }

  String getPublicKeyHex() {
    return _publicKey.toCompressedHex();
  }

  String sign(List<int> bytes) {
    return deterministicSign(_privateKey, bytes).toCompactHex();
  }
}
