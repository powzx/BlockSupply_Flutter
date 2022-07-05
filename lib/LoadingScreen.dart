import 'dart:async';

import 'package:blocksupply_flutter/InitScreen.dart';
import 'package:blocksupply_flutter/Signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoadingScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;
  final bool isNewUser;

  LoadingScreen({Key key, this.client, this.signer, this.isNewUser})
      : super(key: key);

  @override
  _LoadingScreenState createState() =>
      _LoadingScreenState(client: client, signer: signer, isNewUser: isNewUser);
}

class _LoadingScreenState extends State<LoadingScreen> {
  final MqttServerClient client;
  final bool isNewUser;
  final Signer signer;

  _LoadingScreenState({this.client, this.signer, this.isNewUser});

  startTimeout() {
    return Timer(Duration(seconds: 3), changeScreen);
  }

  changeScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InitScreen(
            client: client,
            signer: signer,
            isNewUser: isNewUser,
          );
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
                "Hello.", // Replace with app title or logo if any
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
