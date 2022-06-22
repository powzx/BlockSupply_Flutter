import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final String result;

  ResultScreen({Key key, this.result}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState(result: result);
}

class _ResultScreenState extends State<ResultScreen> {
  final String result;

  _ResultScreenState({this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
    );
  }
}
