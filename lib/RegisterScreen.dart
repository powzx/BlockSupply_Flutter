import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class RegisterScreen extends StatefulWidget{
  final MqttServerClient client;
  final String uuid;

  RegisterScreen({Key key, this.client, this.uuid}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState(client: client, uuid: uuid);
}

class _RegisterScreenState extends State<RegisterScreen> {
  final MqttServerClient client;
  final String uuid;

  _RegisterScreenState({this.client, this.uuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
