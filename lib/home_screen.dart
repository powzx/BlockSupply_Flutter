import 'dart:convert';

import 'package:blocksupply_flutter/result_screen.dart';
import 'package:blocksupply_flutter/signer.dart';
import 'package:blocksupply_flutter/transaction.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  HomeScreen({Key key, this.client, this.signer}) : super(key: key);

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(client: client, signer: signer);
}

class _HomeScreenState extends State<HomeScreen> {
  final MqttServerClient client;
  final Signer signer;

  _HomeScreenState({this.client, this.signer});

  TextEditingController serialNumController = new TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('BlockSupply'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Enter Serial Number",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                controller: serialNumController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Serial Number',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: TextButton(
                child: Text("REQUEST"),
                onPressed: () {
                  final serialNum = serialNumController.text;

                  var builder = MqttClientPayloadBuilder();
                  String message =
                      "{\"serialNum\":\"$serialNum\",\"userPubKey\":\"${this.signer.getPublicKeyHex()}\"}";

                  builder.addString(message);

                  client.publishMessage(
                      getTopic, MqttQos.atLeastOnce, builder.payload);
                  print(
                      'Published message of topic: $getTopic and message: $message');

                  serialNumController.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
