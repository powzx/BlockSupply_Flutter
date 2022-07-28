import 'dart:io';

import 'package:blocksupply_flutter/constants.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

SecurityContext myContext;

Future<MqttServerClient> mqttConnect() async {
  MqttServerClient client =
      MqttServerClient.withPort(serverIp, identifier, 8883)
        ..onBadCertificate = (dynamic x509certificate) {
          return true;
        }; // work around for self signed certificates

  client.secure = true;
  client.securityContext = myContext;

  client.logging(on: false);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onSubscribed = onSubscribed;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMessage = MqttConnectMessage()
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);

  client.connectionMessage = connMessage;

  try {
    await client.connect();
  } catch (exception) {
    print('Exception: $exception');
    client.disconnect();
  }

  return client;
}

void onConnected() {
  print('Connected to MQTT Broker at $serverIp');
}

void onDisconnected() {
  print('Disconnected from MQTT Broker at $serverIp');
}

void onSubscribed(String topic) {
  print('Subscribed to topic: $topic');
}

void onSubscribeFail(String topic) {
  print('Failed to subscribe to topic: $topic');
}

void onUnsubscribed(String topic) {
  print('Unsubscribed from topic: $topic');
}

void pong() {
  print('Ping response client callback invoked');
}
