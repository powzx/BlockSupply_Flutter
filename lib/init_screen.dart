import 'dart:convert';

import 'package:blocksupply_flutter/login_screen.dart';
import 'package:blocksupply_flutter/result_screen.dart';
import 'package:blocksupply_flutter/setup_screen.dart';
import 'package:blocksupply_flutter/signer.dart';
import 'package:blocksupply_flutter/transaction.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class InitScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  InitScreen({this.client, this.signer});

  @override
  _InitScreen createState() => _InitScreen(client: client, signer: signer);
}

class _InitScreen extends State<InitScreen> {
  final MqttServerClient client;
  final Signer signer;

  _InitScreen({this.client, this.signer});

  @override
  void initState() {
    super.initState();

    // Attach dedicated listener
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      final topic = c[0].topic;
      final payload =
      MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message: $payload from topic: $topic');

      if (topic == "/topic/${this.signer.getPublicKeyHex()}/response/get") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ResultScreen(client: client, resultString: payload);
        }));
      } else if (topic ==
          "/topic/${this.signer.getPublicKeyHex()}/response/post") {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Success"),
                content: Text("Account created!"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK")),
                ],
              );
            });
      } else if (topic == updateTopic) {
        final newPayloadJson = json.decode(payload);
        newTxnList.add(new Transaction(
            newPayloadJson['data']['time'],
            newPayloadJson['data']['temp'],
            newPayloadJson['data']['humidity'],
            '',
            ''));
        print('Received updated transaction');
      } else {
        print('No specified handler for this topic');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signer.hasSetUp) {
      return LoginScreen(client: client, signer: signer,);
    }

    return SetupScreen(client: client, signer: signer,);
  }
}
