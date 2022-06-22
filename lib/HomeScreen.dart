import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final MqttServerClient client;

  HomeScreen({Key key, this.title, this.client}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState(title: title, client: client);
}

class _HomeScreenState extends State<HomeScreen> {
  final String title;
  final MqttServerClient client;

  _HomeScreenState({this.title, this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
    );
  }
}
