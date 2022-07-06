import 'dart:async';
import 'package:blocksupply_flutter/Signer.dart';
import 'package:blocksupply_flutter/mqtt.dart';
import 'package:blocksupply_flutter/state_machine.dart';
import 'package:blocksupply_flutter/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttServerClient client;
Signer signer;

Future<Signer> initSigner() async {
  StorageService _storageService = new StorageService();
  Signer signer;
  if (await _storageService.containsKeyInSecureData('blockchain_private_key')) {
    signer = new Signer.fromExisting(
        await _storageService.readSecureData('blockchain_private_key'));
  } else {
    signer = new Signer();
  }
  return signer;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  client = await mqttConnect();
  signer = await initSigner();

  // To remove secure data conveniently for debug purposes
  // Comment these two lines for actual workflow
  StorageService _storageService = StorageService();
  _storageService.deleteAllSecureData();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    updateState(States.LOADING);
    return MaterialApp(
      title: 'BlockSupply',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: StateMachine(
        client: client,
        signer: signer,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
