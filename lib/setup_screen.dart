import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SetupScreen extends StatefulWidget {
  final MqttServerClient client;

  SetupScreen({this.client});

  @override
  _SetupScreen createState() => _SetupScreen(client: client);
}

class _SetupScreen extends State<SetupScreen> {
  final MqttServerClient client;

  _SetupScreen({this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
