import 'package:blocksupply_flutter/Signer.dart';
import 'package:blocksupply_flutter/mqtt.dart';
import 'package:mqtt_client/mqtt_client.dart';

class User {
  String name = '';
  String email = '';
  String mobile = '';
  Signer signer;

  User(dynamic dataJson, Signer signer) {
    this.signer = signer;

    this.name = dataJson['${signer.getPublicKeyHex()}']['name'];
    this.email = dataJson['${signer.getPublicKeyHex()}']['email'];
    this.mobile = dataJson['${signer.getPublicKeyHex()}']['mobile'];
  }
}
