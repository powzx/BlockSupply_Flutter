import 'package:blocksupply_flutter/draft_contract_screen.dart';
import 'package:blocksupply_flutter/signer.dart';
import 'package:blocksupply_flutter/view_contracts_screen.dart';
import 'package:blocksupply_flutter/view_ledgers_screen.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  HomeScreen({Key key, this.client, this.signer}) : super(key: key);

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(client: client, signer: signer);
}

class _HomeScreenState extends State<HomeScreen> {
  final MqttServerClient client;
  final Signer signer;

  _HomeScreenState({this.client, this.signer});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('BlockSupply'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.logout_outlined)),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80.0,
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ViewLedgersScreen(
                          client: client,
                          signer: signer,
                        );
                      }));
                    },
                    child: Text(
                      "View ledgers",
                      style: TextStyle(fontSize: 16.0),
                    )),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80.0,
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return DraftContractScreen(
                          client: client,
                          signer: signer,
                        );
                      }));
                    },
                    child: Text(
                      "Draft contract",
                      style: TextStyle(fontSize: 16.0),
                    )),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80.0,
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      var builder = MqttClientPayloadBuilder();
                      String message =
                          "{\"serialNum\":\"${this.signer.getPublicKeyHex()}\",\"userPubKey\":\"${this.signer.getPublicKeyHex()}\"}";

                      builder.addString(message);

                      client.publishMessage('/topic/dispatch/getContract',
                          MqttQos.atLeastOnce, builder.payload);
                    },
                    child: Text(
                      "View contracts",
                      style: TextStyle(fontSize: 16.0),
                    )),
              ),
            ],
          ),
        ),
        onWillPop: () async => false);
  }
}
