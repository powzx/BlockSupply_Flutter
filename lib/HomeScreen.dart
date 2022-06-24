import 'dart:convert';

import 'package:blocksupply_flutter/GetScreen.dart';
import 'package:blocksupply_flutter/LoadScreen.dart';
import 'package:blocksupply_flutter/ResultScreen.dart';
import 'package:blocksupply_flutter/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final MqttServerClient client;
  final String uuid;

  HomeScreen({Key key, this.title, this.client, this.uuid}) : super(key: key);

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(title: title, client: client, uuid: uuid);
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final String title;
  final MqttServerClient client;
  final String uuid;

  _HomeScreenState({this.title, this.client, this.uuid});

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);

    // Attach dedicated listener
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload;
      final topic = c[0].topic;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message: $payload from topic: $topic');

      if (topic == "/topic/users/${this.uuid}") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ResultScreen(client: client, resultString: payload);
        }));
      } else if (topic == updateTopic) {
        final newPayloadJson = json.decode(payload);
        newTxnList.add(new Transaction(
            newPayloadJson['data']['time'],
            newPayloadJson['data']['temp'],
            newPayloadJson['data']['humidity'],
            '',
            ''));
        print('Received updated transaction');
      } else {
        print('No specified handler for this topic');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: _tabController,
          labelStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
          ),
          tabs: <Widget>[
            Tab(
              text: "LOAD",
            ),
            Tab(
              text: "GET",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          LoadScreen(client: client, uuid: uuid,),
          GetScreen(client: client, uuid: uuid,),
        ],
      ),
    );
  }
}
