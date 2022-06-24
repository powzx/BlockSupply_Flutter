import 'package:blocksupply_flutter/ResultScreen.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class GetScreen extends StatefulWidget {
  final MqttServerClient client;
  final String uuid;

  GetScreen({Key key, this.client, this.uuid}) : super(key: key);

  @override
  _GetScreenState createState() => _GetScreenState(client: client, uuid: uuid);
}

class _GetScreenState extends State<GetScreen> {
  final MqttServerClient client;
  final String uuid;

  _GetScreenState({this.client, this.uuid});

  TextEditingController serialNumController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    "{\"serialNum\":\"$serialNum\",\"uuid\":\"${this.uuid}\"}";

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
    );
  }
}