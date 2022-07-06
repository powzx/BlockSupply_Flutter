import 'dart:convert';
import 'dart:io';

import 'package:blocksupply_flutter/Signer.dart';
import 'package:blocksupply_flutter/User.dart';
import 'package:blocksupply_flutter/login_state.dart';
import 'package:blocksupply_flutter/setup_state.dart';
import 'package:blocksupply_flutter/state_machine.dart';
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

Future<void> mqttConnect() async {
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
}

void attachListeners() {
  mqttClient.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage message = c[0].payload;
    final topic = c[0].topic;
    final payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    print('Received message: $payload from topic: $topic');

    if (topic == "/topic/users/${signer.getPublicKeyHex()}") {
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (BuildContext context) {
      //   return ResultScreen(client: client, resultString: payload);
      // }));
      updateState(States.RESULT);
      // } else if (topic == updateTopic) {
      //   final newPayloadJson = json.decode(payload);
      //   newTxnList.add(new Transaction(
      //       newPayloadJson['data']['time'],
      //       newPayloadJson['data']['temp'],
      //       newPayloadJson['data']['humidity'],
      //       '',
      //       ''));
      //   print('Received updated transaction');
    } else if (topic == "/topic/${signer.getPublicKeyHex()}/txnHash") {
      print("Signing transaction hash: $payload");
      String txnSig = signer.sign(message.payload.message);

      var builder = MqttClientPayloadBuilder();
      builder.addString(txnSig);
      mqttClient.publishMessage("/topic/${signer.getPublicKeyHex()}/txnSig",
          MqttQos.atLeastOnce, builder.payload);

      print("Sending transaction signature: $txnSig");
    } else if (topic == "/topic/${signer.getPublicKeyHex()}/batchHash") {
      print("Signing batch hash: $payload");
      String batchSig = signer.sign(message.payload.message);

      var builder = MqttClientPayloadBuilder();
      builder.addString(batchSig);
      mqttClient.publishMessage("/topic/${signer.getPublicKeyHex()}/batchSig",
          MqttQos.atLeastOnce, builder.payload);

      print("Sending batch signature: $batchSig");
    } else if (topic == "/topic/${signer.getPublicKeyHex()}/user/details") {
      print("Received user details: $payload");
      User user = new User(jsonDecode(payload), signer);
      loginStreamController.sink.add(user);
    } else if (topic == "/topic/${signer.getPublicKeyHex()}/response") {
      updateSetUpSubState(SetUpSubState.SUCCESS);
    } else {
      print('No specified handler for this topic');
    }
  });
}

void subscribeToTopics() {
  mqttClient.subscribe(
      "/topic/users/${signer.getPublicKeyHex()}", MqttQos.atLeastOnce);
  mqttClient.subscribe(
      "/topic/${signer.getPublicKeyHex()}/txnHash", MqttQos.atLeastOnce);
  mqttClient.subscribe(
      "/topic/${signer.getPublicKeyHex()}/batchHash", MqttQos.atLeastOnce);
  mqttClient.subscribe(
      "/topic/${signer.getPublicKeyHex()}/user/details", MqttQos.atLeastOnce);
  mqttClient.subscribe(
      "/topic/${signer.getPublicKeyHex()}/response", MqttQos.atLeastOnce);
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
