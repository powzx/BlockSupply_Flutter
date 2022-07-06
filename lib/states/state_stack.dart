import 'package:blocksupply_flutter/states/state_machine.dart';

class StateStack {
  List<States> stack = [];

  void push(States state) {
    stack.add(state);
  }

  void pop() {
    if (stack.length > 0) {
      stack.removeLast();
    } else {

    }
  }

  String toString() {
    return stack.toString();
  }
}
