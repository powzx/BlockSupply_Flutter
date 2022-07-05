import 'dart:convert';

import 'package:blocksupply_flutter/LoginScreen.dart';
import 'package:blocksupply_flutter/ResultScreen.dart';
import 'package:blocksupply_flutter/SetUpScreen.dart';
import 'package:blocksupply_flutter/Signer.dart';
import 'package:blocksupply_flutter/Transaction.dart';
import 'package:blocksupply_flutter/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class InitScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  InitScreen({Key key, this.client, this.signer}) : super(key: key);

  @override
  _InitScreenState createState() =>
      _InitScreenState(client: client, signer: signer);
}

class _InitScreenState extends State<InitScreen> {
  final MqttServerClient client;
  final Signer signer;

  _InitScreenState({this.client, this.signer});

  StorageService _storageService = new StorageService();

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

      if (topic == "/topic/users/${signer.getPublicKeyHex()}") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ResultScreen(client: client, resultString: payload);
        }));
      } else if (topic == updateTopic) {
        final newPayloadJson = json.decode(payload);
        newTxnList.add(new Transaction(
            newPayloadJson['data']['time'],
            newPayloadJson['data']['temp'],
            newPayloadJson['data']['humidity'],
            '',
            ''));
        print('Received updated transaction');
      } else if (topic == "/topic/${signer.getPublicKeyHex()}/txnHash") {
        print("Signing transaction hash: $payload");
        String txnSig = signer.sign(message.payload.message);

        var builder = MqttClientPayloadBuilder();
        builder.addString(txnSig);
        client.publishMessage("/topic/${signer.getPublicKeyHex()}/txnSig",
            MqttQos.atLeastOnce, builder.payload);

        print("Sending transaction signature: $txnSig");
      } else if (topic == "/topic/${signer.getPublicKeyHex()}/batchHash") {
        print("Signing batch hash: $payload");
        String batchSig = signer.sign(message.payload.message);

        var builder = MqttClientPayloadBuilder();
        builder.addString(batchSig);
        client.publishMessage("/topic/${signer.getPublicKeyHex()}/batchSig",
            MqttQos.atLeastOnce, builder.payload);

        print("Sending batch signature: $batchSig");
      } else {
        print('No specified handler for this topic');
      }
    });

    client.subscribe("/topic/users/${signer.getPublicKeyHex()}", MqttQos.atLeastOnce);
    client.subscribe("/topic/${signer.getPublicKeyHex()}/txnHash", MqttQos.atLeastOnce);
    client.subscribe("/topic/${signer.getPublicKeyHex()}/batchHash", MqttQos.atLeastOnce);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _storageService.readSecureData('blockchain_private_key'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return LoginScreen(
              client: client,
              signer: signer,
            );
          } else {
            return SetUpScreen(
              client: client,
              signer: signer,
            );
          }
        });
  }
}
