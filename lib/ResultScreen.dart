import 'dart:convert';

import 'package:blocksupply_flutter/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

TooltipBehavior _tempTooltipBehavior;
TooltipBehavior _humidityTooltipBehavior;

final String getTopic = '/topic/dispatch/get';

class ResultScreen extends StatefulWidget {
  final String resultString;

  ResultScreen({Key key, this.resultString}) : super(key: key);

  @override
  _ResultScreenState createState() =>
      _ResultScreenState(resultString: resultString);
}

class _ResultScreenState extends State<ResultScreen> {
  final String resultString;

  _ResultScreenState({this.resultString});

  dynamic resultJson;
  String serialNum;

  TransactionDataSource txnDataSource;

  // var builder;
  // var topic;
  // var message;

  @override
  void initState() {
    _tempTooltipBehavior = TooltipBehavior(enable: true);
    _humidityTooltipBehavior = TooltipBehavior(enable: true);

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
    List<Transaction> txnList = createTransactions();
    TransactionDataSource txnDataSource = createTransactionDataSource(txnList);

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
                  color: const Color(0xff009889),
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Temperature'),
                  legend: Legend(isVisible: false),
                  series: <LineSeries<Transaction, num>>[
                    LineSeries<Transaction, num>(
                        name: 'Temperature',
                        color: Colors.blue,
                        enableTooltip: true,
                        dataSource: txnList,
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
                            isVisible: false,
                            labelAlignment: ChartDataLabelAlignment.auto)),
                  ],
                  tooltipBehavior: _tempTooltipBehavior,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Humidity'),
                  legend: Legend(isVisible: false),
                  series: <LineSeries<Transaction, num>>[
                    LineSeries<Transaction, num>(
                        name: 'Humidity',
                        color: Colors.red,
                        enableTooltip: true,
                        dataSource: txnList,
                        xValueMapper: (Transaction transaction, _) =>
                            int.parse(transaction.secondsSinceEpoch),
                        yValueMapper: (Transaction transaction, _) =>
                            int.parse(transaction.humidity),
                        width: 2,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          height: 4,
                          width: 4,
                          shape: DataMarkerType.circle,
                          borderWidth: 3,
                          borderColor: Colors.black,
                        ),
                        dataLabelSettings: DataLabelSettings(
                            isVisible: false,
                            labelAlignment: ChartDataLabelAlignment.auto))
                  ],
                  tooltipBehavior: _humidityTooltipBehavior,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: Text('All Records'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: const Color(0xff009889),
                  ),
                  child: SfDataGrid(
                    headerRowHeight: 40.0,
                    rowHeight: 40.0,
                    source: txnDataSource,
                    columns: [
                      GridColumn(
                          columnName: 'datetime',
                          width: 180.0,
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Date/Time',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      GridColumn(
                          columnName: 'temp',
                          width: 120.0,
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Temperature',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      GridColumn(
                          columnName: 'humidity',
                          width: 100.0,
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Humidity',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      GridColumn(
                          columnName: 'signer',
                          width: 140.0,
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Signer',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      GridColumn(
                          columnName: 'public key',
                          width: 600.0,
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Public Key',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ],
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  TransactionDataSource createTransactionDataSource(List<Transaction> txnList) {
    txnDataSource = TransactionDataSource(transactions: txnList);
    return txnDataSource;
  }
}
