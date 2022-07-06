import 'dart:async';

import 'package:blocksupply_flutter/Signer.dart';
import 'package:blocksupply_flutter/loading_state.dart';
import 'package:blocksupply_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

enum States {
  LOADING,
  SETUP,
  LOGIN,
  HOME,
  RESULT,
}

StreamController<States> stateStreamController = new StreamController<States>();

void updateState(States state) {
  stateStreamController.sink.add(state);
}

class StateMachine extends StatefulWidget {
  final MqttServerClient client;
  final Signer signer;

  StateMachine({Key key, this.client, this.signer}) : super(key: key);

  @override
  _StateMachineState createState() => _StateMachineState();
}

class _StateMachineState extends State<StateMachine> {

  Widget _renderState(States state) {
    if (state == States.LOADING) {
      return LoadingState(
        client: client,
        signer: signer,
      );
    } else if (state == States.LOGIN) {
      return Column();
    } else if (state == States.SETUP) {
      return Column();
    } else if (state == States.HOME) {
      return Column();
    } else if (state == States.RESULT) {
      return Column();
    } else {
      return Column();
      // Navigator.of(context).push(
      //   MaterialPageRoute(builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text("Oh no!"),
      //       content: Text("Unknown error occurred. Please restart the app."),
      //       actions: <Widget>[
      //         TextButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: Text("OK")),
      //       ],
      //     );
      //   })
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: stateStreamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              _renderState(snapshot.data),
        ));
  }
}
