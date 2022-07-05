import 'package:blocksupply_flutter/Signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoginScreen extends StatefulWidget {
  final MqttServerClient client;
  final String uuid;
  final Signer signer;

  LoginScreen({Key key, this.client, this.uuid, this.signer}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState(client: client, uuid: uuid, signer: signer);
}

class _LoginScreenState extends State<LoginScreen> {
  final MqttServerClient client;
  final String uuid;
  final Signer signer;

  _LoginScreenState({this.client, this.uuid, this.signer});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
