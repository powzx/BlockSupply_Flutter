import 'package:blocksupply_flutter/storage_service.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
import 'package:local_auth/local_auth.dart';

class Signer {
  PublicKey _publicKey;
  PrivateKey _privateKey;

  final LocalAuthentication _localAuthentication = new LocalAuthentication();
  final StorageService _storageService = new StorageService();

  Signer() {
    var curve = getSecp256k1();

    _privateKey = curve.generatePrivateKey();
    _publicKey = _privateKey.publicKey;

    _storageService.writeSecureData(
        new StorageItem('blockchain_private_key', _privateKey.toHex()));

    print('Public Key generated: ${_publicKey.toCompressedHex()}');
  }

  Signer.fromExisting(String privateKey) {
    var curve = getSecp256k1();

    _privateKey = PrivateKey.fromHex(curve, privateKey);
    _publicKey = _privateKey.publicKey;
  }

  String getPublicKeyHex() {
    return _publicKey.toCompressedHex();
  }

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    return canCheckBiometrics;
  }

  String sign(List<int> bytes) {
    return deterministicSign(_privateKey, bytes).toCompactHex();
  }
}
