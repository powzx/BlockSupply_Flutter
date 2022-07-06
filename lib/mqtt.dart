import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttServerClient mqttClient;
final identifier = 'Flutter-Client';
final serverIp = '192.168.11.109';

Future<SecurityContext> setMyContext() async {
  ByteData caData = await rootBundle.load('data/ca.crt');
  ByteData keyData = await rootBundle.load('data/client.key');
  ByteData certData = await rootBundle.load('data/client.crt');

  SecurityContext myContext = new SecurityContext()
    ..useCertificateChainBytes(certData.buffer.asUint8List())
    ..usePrivateKeyBytes(keyData.buffer.asUint8List())
    ..setClientAuthoritiesBytes(caData.buffer.asUint8List());

  return myContext;
}

Future<MqttServerClient> mqttConnect() async {
  SecurityContext myContext = await setMyContext();

  mqttClient = MqttServerClient.withPort(serverIp, identifier, 8883)
    ..onBadCertificate = (dynamic x509certificate) {
      return true;
    }; // work around for self signed certificates

  mqttClient.secure = true;
  mqttClient.securityContext = myContext;

  mqttClient.logging(on: false);
  mqttClient.onConnected = onConnected;
  mqttClient.onDisconnected = onDisconnected;
  mqttClient.onSubscribed = onSubscribed;
  mqttClient.onUnsubscribed = onUnsubscribed;
  mqttClient.onSubscribeFail = onSubscribeFail;
  mqttClient.pongCallback = pong;

  final connMessage = MqttConnectMessage()
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);

  mqttClient.connectionMessage = connMessage;

  try {
    await mqttClient.connect();
  } catch (exception) {
    print('Exception: $exception');
    mqttClient.disconnect();
  }

  return mqttClient;
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
