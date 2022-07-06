import 'package:blocksupply_flutter/Signer.dart';
import 'package:blocksupply_flutter/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

class HomeState extends StatelessWidget {
  final TextEditingController serialNumController = new TextEditingController();

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
                    "{\"serialNum\":\"$serialNum\",\"uuid\":\"${signer.getPublicKeyHex()}\"}";

                builder.addString(message);

                mqttClient.publishMessage('/topic/dispatch/sensor/get',
                    MqttQos.atLeastOnce, builder.payload);
                print(
                    'Published message of topic: /topic/dispatch/sensor/get and message: $message');

                serialNumController.clear();
              },
            ),
          ),
        ),
      ],
    );
  }
}
