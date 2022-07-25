import 'package:blocksupply_flutter/result_screen.dart';
import 'package:blocksupply_flutter/signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ViewLedgersScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  ViewLedgersScreen({this.client, this.signer});

  @override
  _ViewLedgersScreenState createState() => _ViewLedgersScreenState(
        client: client,
        signer: signer,
      );
}

class _ViewLedgersScreenState extends State<ViewLedgersScreen> {
  final MqttServerClient client;
  final Signer signer;

  _ViewLedgersScreenState({this.client, this.signer});

  TextEditingController serialNumController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Ledgers"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      '/topic/dispatch/getESP', MqttQos.atLeastOnce, builder.payload);
                  // print(
                  //     'Published message of topic: $getTopic and message: $message');

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
