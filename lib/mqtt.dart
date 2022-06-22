import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

SecurityContext myContext;

final identifier = 'Flutter-Client-1';
final serverIp = '192.168.11.109';

Future<MqttServerClient> mqttConnect() async {
  MqttServerClient client =
      MqttServerClient.withPort(serverIp, identifier, 8883)
        ..onBadCertificate = (dynamic x509certificate) {
          return true;
        }; // work around for self signed certificates

  client.secure = true;
  client.securityContext = myContext;

  client.logging(on: true);
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

  client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage message = c[0].payload;
    final payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    print('Received message: $payload from topic: ${c[0].topic}');
  });

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
