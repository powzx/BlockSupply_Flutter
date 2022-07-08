import 'package:blocksupply_flutter/storage_service.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';

Future<Signer> initSigner() async {
  Signer signer;
  StorageService _storageService = new StorageService();
  if (await _storageService.containsKeyInSecureData('blockchain_private_key')) {
    signer = new Signer.fromExisting(
        await _storageService.readSecureData('blockchain_private_key'));
  } else {
    signer = new Signer();
  }
  return signer;
}

class Signer {
  PublicKey _publicKey;
  PrivateKey _privateKey;
  String username;
  bool hasSetUp = false;

  final StorageService _storageService = new StorageService();

  Signer() {
    var curve = getSecp256k1();

    _privateKey = curve.generatePrivateKey();
    _publicKey = _privateKey.publicKey;

    print('Created new public key: ${this.getPublicKeyHex()}');
  }

  Signer.fromExisting(String privateKey) {
    var curve = getSecp256k1();

    _privateKey = PrivateKey.fromHex(curve, privateKey);
    _publicKey = _privateKey.publicKey;

    print('Found public key: ${this.getPublicKeyHex()}');
  }

  void checkSetup() async {
    if (await _storageService.containsKeyInSecureData('blockchain_username')) {
      this.username = await _storageService.readSecureData('blockchain_username');
      this.hasSetUp = true;
    }
  }

  void writeUsernameToSecureStorage(String username) {
    this.username = username;
    _storageService
        .writeSecureData(new StorageItem('blockchain_username', username));
  }

  void writePrivateKeyToSecureStorage() {
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
