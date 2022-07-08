import 'package:blocksupply_flutter/signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DraftContractScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  DraftContractScreen({this.client, this.signer});

  @override
  _DraftContractScreenState createState() =>
      _DraftContractScreenState(client: client, signer: signer);
}

class _DraftContractScreenState extends State<DraftContractScreen> {
  final MqttServerClient client;
  final Signer signer;

  _DraftContractScreenState({this.client, this.signer});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
