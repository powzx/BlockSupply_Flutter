import 'package:blocksupply_flutter/Signer.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class User {
  String name = '';
  String email = '';
  String mobile = '';
  Signer signer;

  User(Signer signer, MqttServerClient client) {
    this.signer = signer;

    var builder = MqttClientPayloadBuilder();
    String message =
        "{\"serialNum\":\"${this.signer.getPublicKeyHex()}\",\"uuid\":\"${this.signer.getPublicKeyHex()}\"}";
    builder.addString(message);
    client.publishMessage("/topic/dispatch/get",
        MqttQos.atLeastOnce, builder.payload);
  }

  setEntries(dynamic dataJson) {
    this.name = dataJson[signer.getPublicKeyHex()]['name'];
    this.email = dataJson[signer.getPublicKeyHex()]['email'];
    this.mobile = dataJson[signer.getPublicKeyHex()]['mobile'];
  }
}
