import 'dart:async';

import 'package:blocksupply_flutter/Signer.dart';
import 'package:blocksupply_flutter/mqtt.dart';
import 'package:blocksupply_flutter/setup_state.dart';
import 'package:blocksupply_flutter/state_machine.dart';
import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {

  startTimeout() {
    return Timer(Duration(seconds: 3), changeState);
  }

  changeState() async {
    if (signer.hasSetUp) {
      updateState(States.LOGIN);
    } else {
      updateState(States.SETUP);
      // updateSetUpSubState(SetUpSubState.WAITING);
    }
  }

  @override
  Widget build(BuildContext context) {
    attachListeners();
    subscribeToTopics();

    startTimeout();

    return Container(
        margin: EdgeInsets.only(left: 40.0, right: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Hello.", // Replace with app title or logo if any
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              )
            ],
          ),
        ));
  }
}
