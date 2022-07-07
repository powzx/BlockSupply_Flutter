import 'package:flutter/material.dart';

class DraftContractState extends StatelessWidget {
  final TextEditingController _targetEmailController =
      new TextEditingController();
  final TextEditingController _tempLowController = new TextEditingController();
  final TextEditingController _tempHighController = new TextEditingController();
  final TextEditingController _humidityLowController =
      new TextEditingController();
  final TextEditingController _humidityHighController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Draft a new contract",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            controller: _targetEmailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Recipient Email"),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            controller: _tempLowController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Temperature lower limit"),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            controller: _tempHighController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Temperature upper limit"),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            controller: _humidityLowController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Humidity lower limit"),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            controller: _humidityHighController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Humidity upper limit"),
          ),
        ),
        SizedBox(height: 20.0),
        TextButton(onPressed: () {}, child: Text("Submit")),
      ],
    );
  }
}
