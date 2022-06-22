import 'package:blocksupply_flutter/ResultScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  final String title;
  final MqttServerClient client;
  final String uuid;

  _HomeScreenState({this.title, this.client, this.uuid});

  TextEditingController serialNumController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Enter Serial Number",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                controller: serialNumController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Serial Number',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Align(
              alignment: Alignment.center,
              child: TextButton(
                child: Text("REQUEST"),
                onPressed: () {
                  final serialNum = serialNumController.text;
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return ResultScreen(client: client, serialNum: serialNum, uuid: uuid);
                  }));

                  serialNumController.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
