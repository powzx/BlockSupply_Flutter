import 'package:blocksupply_flutter/ResultScreen.dart';
import 'package:blocksupply_flutter/Signer.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                      "{\"serialNum\":\"$serialNum\",\"uuid\":\"${this.signer.getPublicKeyHex()}\"}";

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
