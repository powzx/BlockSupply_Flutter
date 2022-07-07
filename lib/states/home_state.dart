import 'package:blocksupply_flutter/states/state_machine.dart';
import 'package:flutter/material.dart';

class HomeState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          padding: EdgeInsets.all(10.0),
          child: ElevatedButton(
            child: Text(
              "Draft new contract"
            ),
            onPressed: () {
              updateState(States.DRAFT_CONTRACT);
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          padding: EdgeInsets.all(10.0),
          child: ElevatedButton(
            child: Text(
              "View contracts"
            ),
            onPressed: () {
              updateState(States.VIEW_CONTRACT_LIST);
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          padding: EdgeInsets.all(10.0),
          child: ElevatedButton(
            child: Text(
                "Retrieve Data"
            ),
            onPressed: () {
              updateState(States.RETRIEVE_DATA);
            },
          ),
        ),
      ],
    );
  }
}
