import 'dart:convert';

import 'package:blocksupply_flutter/authenticator.dart';
import 'package:blocksupply_flutter/signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

String username = '';

class SetupScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  SetupScreen({this.client, this.signer});

  @override
  _SetupScreen createState() => _SetupScreen(client: client, signer: signer);
}

class _SetupScreen extends State<SetupScreen> {
  final MqttServerClient client;
  final Signer signer;

  _SetupScreen({this.client, this.signer});

  TextEditingController _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            body: Column(
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
                        "data": _nameController.text,
                      }));
                      client.publishMessage("/topic/dispatch/init",
                          MqttQos.atLeastOnce, builder.payload);

                      username = _nameController.text;
                    }
                  },
                ),
              ),
            ])),
        onWillPop: () async => false);
  }
}
