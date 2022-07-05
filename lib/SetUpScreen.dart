import 'dart:convert';

import 'package:blocksupply_flutter/Authenticator.dart';
import 'package:blocksupply_flutter/LoginScreen.dart';
import 'package:blocksupply_flutter/Signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SetUpScreen extends StatefulWidget {
  final MqttServerClient client;
  final String uuid;
  final Signer signer;

  SetUpScreen({Key key, this.client, this.uuid, this.signer}) : super(key: key);

  @override
  _SetUpScreenState createState() =>
      _SetUpScreenState(client: client, uuid: uuid, signer: signer);
}

class _SetUpScreenState extends State<SetUpScreen> {
  final MqttServerClient client;
  final String uuid;
  final Signer signer;

  _SetUpScreenState({this.client, this.uuid, this.signer});

  String _name;
  String _email;
  String _mobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 25.0,
            ),
            child: Text(
              "Set up an account",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Name",
                  prefixIcon: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    _name = value.trim();
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Mobile",
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    _mobile = value.trim();
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: 50.0,
            child: ElevatedButton(
              child: Text(
                'Proceed',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                var authenticator = new Authenticator();

                bool isAuthenticatedWithFingerprint =
                    await authenticator.authenticateWithFingerPrint();

                if (isAuthenticatedWithFingerprint) {

                  var builder = MqttClientPayloadBuilder();
                  builder.addString(jsonEncode({
                    "publicKey": signer.getPublicKeyHex(),
                    "data": {
                      "name": _name,
                      "email": _email,
                      "mobile": _mobile
                    }
                  }));
                  client.publishMessage("/topic/dispatch/init",
                      MqttQos.atLeastOnce, builder.payload);

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return LoginScreen(
                      client: client,
                      uuid: uuid,
                    );
                  }));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
