import 'dart:async';

import 'package:blocksupply_flutter/authenticator.dart';
import 'package:blocksupply_flutter/signer.dart';
import 'package:blocksupply_flutter/user.dart';
import 'package:blocksupply_flutter/mqtt.dart';
import 'package:blocksupply_flutter/state_machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';

enum LoginSubState {
  WAITING,
  SUCCESS,
}

StreamController<LoginSubState> loginStreamController = new StreamController<LoginSubState>();

void updateLoginSubState(LoginSubState subState) {
  loginStreamController.sink.add(subState);
}

class LoginState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var builder = MqttClientPayloadBuilder();
    String message = "{\"publicKey\":\"${signer.getPublicKeyHex()}\"}";
    builder.addString(message);
    mqttClient.publishMessage(
        "/topic/dispatch/user/get", MqttQos.atLeastOnce, builder.payload);

    final snapshot = context.watch<LoginSubState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 25.0,
            ),
            child: snapshot == LoginSubState.WAITING
                ? Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Text(
                    "Welcome back, ${user.name}",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
        SizedBox(
          height: 50.0,
        ),
        Container(
          height: 50.0,
          child: ElevatedButton(
            child: Text(
              'Tap to login',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              var authenticator = new Authenticator();

              bool isAuthenticatedWithFingerprint =
                  await authenticator.authenticateWithFingerPrint();

              if (isAuthenticatedWithFingerprint) {
                updateState(States.HOME);
              }
            },
          ),
        ),
      ],
    );
  }
}
