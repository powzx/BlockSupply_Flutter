import 'dart:async';

import 'package:blocksupply_flutter/Signer.dart';
import 'package:blocksupply_flutter/state_machine.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoadingState extends StatelessWidget {
  final MqttServerClient client;
  final Signer signer;

  LoadingState({this.client, this.signer});

  startTimeout() {
    return Timer(Duration(seconds: 3), changeState);
  }

  changeState() async {
    if (this.signer.hasSetUp) {
      updateState(States.LOGIN);
    } else {
      updateState(States.SETUP);
    }
  }

  @override
  Widget build(BuildContext context) {
    startTimeout();
    return Container(
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
        ));
  }
}
