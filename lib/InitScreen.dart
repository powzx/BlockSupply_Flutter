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
  final String uuid;

  InitScreen({Key key, this.client, this.uuid}) : super(key: key);

  @override
  _InitScreenState createState() =>
      _InitScreenState(client: client, uuid: uuid);
}

class _InitScreenState extends State<InitScreen> {
  final MqttServerClient client;
  final String uuid;

  _InitScreenState({this.client, this.uuid});

  final StorageService _storageService = new StorageService();
  Signer signer;

  @override
  void initState() {
    super.initState();

    _storageService
        .containsKeyInSecureData('blockchain_private_key')
        .then((hasData) => {
              if (hasData)
                {
                  _storageService
                      .readSecureData('blockchain_private_key')
                      .then((key) => signer = new Signer.fromExisting(key))
                }
              else
                {signer = new Signer()}
            });

    // Attach dedicated listener
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      final topic = c[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message: $payload from topic: $topic');

      if (topic == "/topic/users/${this.uuid}") {
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _storageService.readSecureData('blockchain_private_key'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return LoginScreen(
              client: client,
              uuid: uuid,
              signer: signer,
            );
          } else {
            return SetUpScreen(
              client: client,
              uuid: uuid,
              signer: signer,
            );
          }
        });
  }
}
