import 'package:blocksupply_flutter/Signer.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class User {
  String name;
  String email;
  String mobile;
  Signer signer;

  User(Signer signer, MqttServerClient client) {
    this.signer = signer;


  }
}