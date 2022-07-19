import 'package:blocksupply_flutter/signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ViewContractsScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  ViewContractsScreen({this.client, this.signer});

  @override
  _ViewContractsScreenState createState() =>
      _ViewContractsScreenState(client: client, signer: signer);
}

class _ViewContractsScreenState extends State<ViewContractsScreen> {
  final MqttServerClient client;
  final Signer signer;

  _ViewContractsScreenState({this.client, this.signer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contracts"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[],
      ),
    );
  }
}
