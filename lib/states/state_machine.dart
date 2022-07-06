import 'dart:async';

import 'package:blocksupply_flutter/states/error_state.dart';
import 'package:blocksupply_flutter/states/home_state.dart';
import 'package:blocksupply_flutter/states/loading_state.dart';
import 'package:blocksupply_flutter/states/login_state.dart';
import 'package:blocksupply_flutter/states/result_state.dart';
import 'package:blocksupply_flutter/states/setup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  StateMachine({Key key}) : super(key: key);

  @override
  _StateMachineState createState() => _StateMachineState();
}

class _StateMachineState extends State<StateMachine> {

  Widget _renderState(States state) {
    if (state == States.LOADING) {
      return LoadingState();
    } else if (state == States.LOGIN) {
      return LoginState();
    } else if (state == States.SETUP) {
      return SetUpState();
    } else if (state == States.HOME) {
      return HomeState();
    } else if (state == States.RESULT) {
      return ResultState();
    } else {
      return ErrorState();
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
        body: _renderState(context.watch<States>()),
    );
  }
}
