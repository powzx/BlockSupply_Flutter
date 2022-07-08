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
  _InitScreenState createState() => _InitScreenState(client: client, signer: signer);
}

class _InitScreenState extends State<InitScreen> {
  final MqttServerClient client;
  final Signer signer;

  _InitScreenState({this.client, this.signer});

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
              return WillPopScope(
                  child: AlertDialog(
                    title: Text("Success"),
                    content: Text("Account created!"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            signer.writeUsernameToSecureStorage(username);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return LoginScreen(
                                client: client,
                                signer: signer,
                              );
                            }));
                          },
                          child: Text("OK")),
                    ],
                  ),
                  onWillPop: () async => false);
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
      } else if (topic == "/topic/${this.signer.getPublicKeyHex()}/txnHash") {
        print(
            "Signing transaction hash: ${message.payload.message.toString()}");
        String txnSig = this.signer.sign(message.payload.message);

        var builder = MqttClientPayloadBuilder();
        builder.addString(txnSig);
        client.publishMessage("/topic/${signer.getPublicKeyHex()}/txnSig",
            MqttQos.atLeastOnce, builder.payload);

        print("Sending transaction signature: $txnSig");
      } else if (topic == "/topic/${this.signer.getPublicKeyHex()}/batchHash") {
        print("Signing batch hash: ${message.payload.message.toString()}");
        String batchSig = this.signer.sign(message.payload.message);

        var builder = MqttClientPayloadBuilder();
        builder.addString(batchSig);
        client.publishMessage("/topic/${signer.getPublicKeyHex()}/batchSig",
            MqttQos.atLeastOnce, builder.payload);

        print("Sending batch signature: $batchSig");
      } else {
        print('No specified handler for this topic');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signer.hasSetUp) {
      return LoginScreen(
        client: client,
        signer: signer,
      );
    }

    return SetupScreen(
      client: client,
      signer: signer,
    );
  }
}
