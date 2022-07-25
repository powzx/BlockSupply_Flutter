import 'dart:convert';

import 'package:blocksupply_flutter/signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ViewContractsScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;
  final String result;

  ViewContractsScreen({this.client, this.signer, this.result});

  @override
  _ViewContractsScreenState createState() =>
      _ViewContractsScreenState(client: client, signer: signer, result: result);
}

class _ViewContractsScreenState extends State<ViewContractsScreen> {
  final MqttServerClient client;
  final Signer signer;
  final String result;

  _ViewContractsScreenState({this.client, this.signer, this.result});

  @override
  Widget build(BuildContext context) {
    dynamic resultJson = jsonDecode(result);
    List<dynamic> contracts = List.from(resultJson['contracts']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Contracts"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
            child: contracts.isNotEmpty
                ? ListView.builder(
                    itemCount: contracts.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        color: contracts[index]['data']['isSigned']
                            ? Colors.lightGreenAccent
                            : Colors.redAccent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Message: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "${contracts[index]['data']['text']}",
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Sender: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "${contracts[index]['data']['sender']}",
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        // Sign the contract
                                      },
                                      child: Text(
                                        'SIGN',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Text(
                      "No contracts found",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
