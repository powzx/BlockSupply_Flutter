import 'dart:async';
import 'dart:io';
import 'package:blocksupply_flutter/HomeScreen.dart';
import 'package:blocksupply_flutter/mqtt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttServerClient client;

Future<void> setMyContext() async {
  ByteData caData = await rootBundle.load('data/ca.crt');
  ByteData keyData = await rootBundle.load('data/client.key');
  ByteData certData = await rootBundle.load('data/client.crt');

  myContext = new SecurityContext()
    ..useCertificateChainBytes(certData.buffer.asUint8List())
    ..usePrivateKeyBytes(keyData.buffer.asUint8List())
    ..setClientAuthoritiesBytes(caData.buffer.asUint8List());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setMyContext();

  client = await mqttConnect();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlockSupply',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(title: 'BlockSupply', client: client,),
      debugShowCheckedModeBanner: false,
    );
  }
}
