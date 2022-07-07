import 'dart:async';

import 'package:blocksupply_flutter/common/mqtt.dart';
import 'package:blocksupply_flutter/states/error_state.dart';
import 'package:blocksupply_flutter/states/home_state.dart';
import 'package:blocksupply_flutter/states/loading_state.dart';
import 'package:blocksupply_flutter/states/login_state.dart';
import 'package:blocksupply_flutter/states/result_state.dart';
import 'package:blocksupply_flutter/states/setup_state.dart';
import 'package:blocksupply_flutter/states/state_stack.dart';
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
  // StateStack stack = new StateStack();

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
    }
  }

  @override
  void initState() {
    super.initState();
    attachListeners();
    subscribeToTopics();
  }

  @override
  Widget build(BuildContext context) {
    // final snapshot = context.watch<States>();
    // if (snapshot != null) {
    //   stack.push(snapshot);
    //   print(stack);
    // }
    //
    // return WillPopScope(
    //     child: Scaffold(
    //       backgroundColor: Colors.white,
    //       body: _renderState(snapshot),
    //     ),
    //     onWillPop: () async {
    //       stack.pop();
    //       print(stack);
    //       if (stack.stack.isNotEmpty) {
    //         updateState(stack.stack.last);
    //         return false;
    //       }
    //       return true;
    //     });
    return Scaffold(
      backgroundColor: Colors.white,
      body: _renderState(context.watch<States>()),
    );
  }
}
