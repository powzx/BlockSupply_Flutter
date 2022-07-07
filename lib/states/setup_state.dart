import 'dart:async';
import 'dart:convert';

import 'package:blocksupply_flutter/common/authenticator.dart';
import 'package:blocksupply_flutter/common/signer.dart';
import 'package:blocksupply_flutter/common/mqtt.dart';
import 'package:blocksupply_flutter/states/state_machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';

enum SetUpSubState { WAITING, SUCCESS }

StreamController<SetUpSubState> setupStreamController =
    new StreamController<SetUpSubState>();

void updateSetUpSubState(SetUpSubState subState) {
  setupStreamController.sink.add(subState);
}

class SetUpState extends StatelessWidget {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _mobileController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final snapshot = context.watch<SetUpSubState>();

    if (snapshot == SetUpSubState.SUCCESS) {
      signer.writeToSecureStorage();
      Future.delayed(Duration.zero, () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Account created"),
              actions: <Widget>[
                TextButton(
                  child: Text("Login"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    updateState(States.LOGIN);
                  },
                ),
              ],
            );
          }));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: 25.0,
          ),
          child: Text(
            "Set up an account",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Card(
          elevation: 3.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextField(
              controller: _nameController,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "Name",
                prefixIcon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              maxLines: 1,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Card(
          elevation: 3.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextField(
              controller: _emailController,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "Email",
                prefixIcon: Icon(
                  Icons.mail_outline,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              maxLines: 1,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Card(
          elevation: 3.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: TextField(
              controller: _mobileController,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: "Mobile",
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              maxLines: 1,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          height: 50.0,
          child: ElevatedButton(
            child: Text(
              'Proceed',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              var authenticator = new Authenticator();

              bool isAuthenticatedWithFingerprint =
                  await authenticator.authenticateWithFingerPrint();

              if (isAuthenticatedWithFingerprint) {
                var builder = MqttClientPayloadBuilder();
                builder.addString(jsonEncode({
                  "publicKey": signer.getPublicKeyHex(),
                  "key": signer.getPublicKeyHex(),
                  "data": {
                    "name": _nameController.text,
                    "email": _emailController.text,
                    "mobile": _mobileController.text
                  },
                }));
                mqttClient.publishMessage("/topic/dispatch/user/init",
                    MqttQos.atLeastOnce, builder.payload);
              }
            },
          ),
        ),
      ],
    );
  }
}
