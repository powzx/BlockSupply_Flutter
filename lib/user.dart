import 'dart:convert';

import 'package:blocksupply_flutter/signer.dart';

User user;

class User {
  String name;
  String email;
  String mobile;
  Signer signer;

  User(dynamic userJson, Signer signer) {
    this.signer = signer;

    var dataJson = jsonDecode(userJson['${signer.getPublicKeyHex()}']);

    this.name = dataJson['name'];
    this.email = dataJson['email'];
    this.mobile = dataJson['mobile'];
  }
}
