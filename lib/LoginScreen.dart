import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoginScreen extends StatefulWidget {
  final MqttServerClient client;
  final String uuid;

  LoginScreen({Key key, this.client, this.uuid}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState(client: client, uuid: uuid);
}

class _LoginScreenState extends State<LoginScreen> {
  final MqttServerClient client;
  final String uuid;

  _LoginScreenState({this.client, this.uuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
