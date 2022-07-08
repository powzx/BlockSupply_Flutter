import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoginScreen extends StatefulWidget {
  final MqttServerClient client;

  LoginScreen({this.client});

  @override
  _LoginScreen createState() => _LoginScreen(client: client);
}

class _LoginScreen extends State<LoginScreen> {
  final MqttServerClient client;

  _LoginScreen({this.client});

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
