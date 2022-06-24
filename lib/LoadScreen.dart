import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoadScreen extends StatefulWidget {
  final MqttServerClient client;
  final String uuid;

  LoadScreen({Key key, this.client, this.uuid}) : super(key: key);

  @override
  _LoadScreenState createState() =>
      _LoadScreenState(client: client, uuid: uuid);
}

class _LoadScreenState extends State<LoadScreen> {
  final MqttServerClient client;
  final String uuid;

  _LoadScreenState({this.client, this.uuid});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
