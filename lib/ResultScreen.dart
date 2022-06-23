import 'dart:convert';

import 'package:blocksupply_flutter/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

TooltipBehavior _tooltipBehavior;

final String getTopic = '/topic/dispatch/get';

class ResultScreen extends StatefulWidget {
  final String resultString;

  ResultScreen({Key key, this.resultString})
      : super(key: key);

  @override
  _ResultScreenState createState() =>
      _ResultScreenState(resultString: resultString);
}

class _ResultScreenState extends State<ResultScreen> {
  final String resultString;

  _ResultScreenState({this.resultString});

  dynamic resultJson;
  String serialNum;
  // var builder;
  // var topic;
  // var message;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();

    this.resultJson = json.decode(resultString);
    this.serialNum = this.resultJson['serialNum'];
  }

  // void request() {
  //   client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  //   print('Published message of topic: $topic and message: $message');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                      child: Text(
                        "Transaction records for:",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Text(
                        "#${this.serialNum}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height / 3,
              child: SfCartesianChart(
                title: ChartTitle(text: 'Temperature'),
                legend: Legend(isVisible: false),
                series: getTempData(),
                tooltipBehavior: _tooltipBehavior,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Temperature',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Humidity',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Signer',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Public Key',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ], rows: const <DataRow>[
                  DataRow(cells: <DataCell>[
                    DataCell(Text('date')),
                    DataCell(Text('time')),
                    DataCell(Text('temperature')),
                    DataCell(Text('humidity')),
                    DataCell(Text('signer')),
                    DataCell(Text('public key')),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('date')),
                    DataCell(Text('time')),
                    DataCell(Text('temperature')),
                    DataCell(Text('humidity')),
                    DataCell(Text('signer')),
                    DataCell(Text('public key')),
                  ]),
                  DataRow(cells: <DataCell>[
                    DataCell(Text('date')),
                    DataCell(Text('time')),
                    DataCell(Text('temperature')),
                    DataCell(Text('humidity')),
                    DataCell(Text('signer')),
                    DataCell(Text('public key')),
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<LineSeries<Transaction, num>> getTempData() {
    final List<Transaction> chartData = createTransactions();

    return <LineSeries<Transaction, num>>[
      LineSeries<Transaction, num>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (Transaction transaction, _) =>
              int.parse(transaction.secondsSinceEpoch),
          yValueMapper: (Transaction transaction, _) =>
              int.parse(transaction.temperature),
          width: 2,
          markerSettings: MarkerSettings(
              isVisible: true,
              height: 4,
              width: 4,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.black),
          dataLabelSettings: DataLabelSettings(
              isVisible: false, labelAlignment: ChartDataLabelAlignment.auto)),
    ];
  }

  List<Transaction> createTransactions() {
    List<Transaction> txnList = [];

    for (int i = 0; i < this.resultJson['transactions'].length; i++) {
      Transaction transaction = new Transaction(
          this.resultJson['transactions'][i]['transaction']['data']['time'],
          this.resultJson['transactions'][i]['transaction']['data']['temp'],
          this.resultJson['transactions'][i]['transaction']['data']['humidity'],
          this.resultJson['transactions'][i]['authorName'],
          this.resultJson['transactions'][i]['authorKey']);
      txnList.add(transaction);
    }

    return txnList;
  }
}
