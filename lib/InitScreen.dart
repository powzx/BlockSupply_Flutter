import 'package:blocksupply_flutter/LoginScreen.dart';
import 'package:blocksupply_flutter/SetUpScreen.dart';
import 'package:blocksupply_flutter/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class InitScreen extends StatefulWidget {
  final MqttServerClient client;
  final String uuid;

  InitScreen({Key key, this.client, this.uuid}) : super(key: key);

  @override
  _InitScreenState createState() =>
      _InitScreenState(client: client, uuid: uuid);
}

class _InitScreenState extends State<InitScreen> {
  final MqttServerClient client;
  final String uuid;

  _InitScreenState({this.client, this.uuid});

  final StorageService _storageService = new StorageService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _storageService.readSecureData('blockchain_private_key'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return LoginScreen(
              client: client,
              uuid: uuid,
            );
          } else {
            return SetUpScreen(
              client: client,
              uuid: uuid,
            );
          }
        });
  }
}
