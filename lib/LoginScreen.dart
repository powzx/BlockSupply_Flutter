import 'package:blocksupply_flutter/Authenticator.dart';
import 'package:blocksupply_flutter/HomeScreen.dart';
import 'package:blocksupply_flutter/Signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoginScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  LoginScreen({Key key, this.client, this.signer}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState(client: client, signer: signer);
}

class _LoginScreenState extends State<LoginScreen> {
  final MqttServerClient client;
  final Signer signer;

  _LoginScreenState({this.client, this.signer});

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
              "Welcome back",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 50.0,),
          Container(
            height: 50.0,
            child: ElevatedButton(
              child: Text(
                'Tap to login',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                var authenticator = new Authenticator();

                bool isAuthenticatedWithFingerprint =
                await authenticator.authenticateWithFingerPrint();

                if (isAuthenticatedWithFingerprint) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return HomeScreen(
                      client: client,
                      signer: signer,
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
