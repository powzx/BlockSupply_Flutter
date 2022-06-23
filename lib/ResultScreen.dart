import 'package:blocksupply_flutter/Transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

TooltipBehavior _tooltipBehavior;

final String getTopic = '/topic/dispatch/get';

class ResultScreen extends StatefulWidget {
  final MqttServerClient client;
  final String serialNum;
  final String uuid;

  ResultScreen({Key key, this.client, this.serialNum, this.uuid})
      : super(key: key);

  @override
  _ResultScreenState createState() =>
      _ResultScreenState(client: client, serialNum: serialNum, uuid: uuid);
}

class _ResultScreenState extends State<ResultScreen> {
  final MqttServerClient client;
  final String serialNum;
  final String uuid;

  _ResultScreenState({this.client, this.serialNum, this.uuid});

  var builder;
  var topic;
  var message;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();

    builder = MqttClientPayloadBuilder();
    topic = getTopic;
    message = "{\"serialNum\":\"${this.serialNum}\",\"uuid\":\"${this.uuid}\"}";

    builder.addString(message);
  }

  void request() {
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
    print('Published message of topic: $topic and message: $message');
  }

  @override
  Widget build(BuildContext context) {
    request();
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Column(
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
          SfCartesianChart(
            title: ChartTitle(text: 'Temperature'),
            legend: Legend(isVisible: false),
            series: getTempData(),
            tooltipBehavior: _tooltipBehavior,
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
    );
  }

  static List<LineSeries<Transaction, num>> getTempData() {
    final List<Transaction> chartData = <Transaction>[
      Transaction('2022-06-23', '1013', '8', '43', 'ESP32-1', '8fe1a72'),
      Transaction('2022-06-23', '1018', '2', '40', 'ESP32-1', '8fe1a72'),
      Transaction('2022-06-23', '1023', '1', '32', 'ESP32-1', '8fe1a72'),
    ];

    return <LineSeries<Transaction, num>>[
      LineSeries<Transaction, num>(
          enableTooltip: true,
          dataSource: chartData,
          xValueMapper: (Transaction transaction, _) =>
              int.parse(transaction.time),
          yValueMapper: (Transaction transaction, _) =>
              int.parse(transaction.temperature),
          width: 2,
          markerSettings: MarkerSettings(
              isVisible: true,
              height: 4,
              width: 4,
              shape: DataMarkerType.circle,
              borderWidth: 3,
              borderColor: Colors.red),
          dataLabelSettings: DataLabelSettings(
              isVisible: false, labelAlignment: ChartDataLabelAlignment.auto)),
    ];
  }
}
