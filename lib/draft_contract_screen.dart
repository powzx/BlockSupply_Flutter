import 'dart:convert';

import 'package:blocksupply_flutter/authenticator.dart';
import 'package:blocksupply_flutter/signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DraftContractScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  DraftContractScreen({this.client, this.signer});

  @override
  _DraftContractScreenState createState() =>
      _DraftContractScreenState(client: client, signer: signer);
}

class _DraftContractScreenState extends State<DraftContractScreen> {
  final MqttServerClient client;
  final Signer signer;

  _DraftContractScreenState({this.client, this.signer});

  TextEditingController _messageController = new TextEditingController();
  TextEditingController _recipientController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draft a contract"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                controller: _recipientController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Recipient',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Message',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: TextButton(
                child: Text("Send"),
                onPressed: () async {
                  var authenticator = new Authenticator();

                  bool isAuthenticatedWithFingerprint =
                      await authenticator.authenticateWithFingerPrint();

                  if (isAuthenticatedWithFingerprint) {
                    var builder = MqttClientPayloadBuilder();
                    builder.addString(jsonEncode({
                      "publicKey": signer.getPublicKeyHex(),
                      "key": _recipientController.text,
                      "data": jsonEncode({
                        "sender": signer.getUsername(),
                        "text": _messageController.text,
                        "isSigned": false,
                      }),
                    }));

                    client.publishMessage("/topic/dispatch/contract",
                        MqttQos.atLeastOnce, builder.payload);

                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Success"),
                            content: Text("Contract sent!"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK")),
                            ],
                          );
                        });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
