import 'package:blocksupply_flutter/authenticator.dart';
import 'package:blocksupply_flutter/home_screen.dart';
import 'package:blocksupply_flutter/signer.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoginScreen extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  LoginScreen({this.client, this.signer});

  @override
  _LoginScreen createState() => _LoginScreen(client: client, signer: signer);
}

class _LoginScreen extends State<LoginScreen> {
  final MqttServerClient client;
  final Signer signer;

  _LoginScreen({this.client, this.signer});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
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
                  )),
              SizedBox(
                height: 50.0,
              ),
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
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
        ),
        onWillPop: () async => false);
  }
}
