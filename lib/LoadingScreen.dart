import 'dart:async';

import 'package:blocksupply_flutter/HomeScreen.dart';
import 'package:blocksupply_flutter/JoinScreen.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoadingScreen extends StatefulWidget {
  final MqttServerClient client;
  final String uuid;

  LoadingScreen({Key key, this.client, this.uuid}) : super(key: key);

  @override
  _LoadingScreenState createState() =>
      _LoadingScreenState(client: client, uuid: uuid);
}

class _LoadingScreenState extends State<LoadingScreen> {
  final MqttServerClient client;
  final String uuid;

  _LoadingScreenState({this.client, this.uuid});

  startTimeout() {
    return Timer(Duration(seconds: 3), changeScreen);
  }

  changeScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return JoinScreen(client: client, uuid: uuid,);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 40.0, right: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome", // Replace with app title if any
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
