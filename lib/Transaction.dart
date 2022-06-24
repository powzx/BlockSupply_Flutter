import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Transaction {
  String secondsSinceEpoch;
  DateTime dateTime;
  String dateTimeStr;
  String temperature;
  String humidity;
  String signer;
  String publicKey;

  Transaction(secondsSinceEpoch, temperature, humidity, signer, publicKey) {
    this.secondsSinceEpoch = secondsSinceEpoch;
    this.temperature = temperature;
    this.humidity = humidity;
    this.signer = signer;
    this.publicKey = publicKey;

    this.dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(secondsSinceEpoch) * 1000);

    DateFormat f = new DateFormat('yyyy-MM-dd HH:mm');
    this.dateTimeStr = f.format(dateTime);
  }

  @override
  String toString() {
    return "{secondsSinceEpoch: $secondsSinceEpoch, temperature: $temperature, humidity: $humidity, signer: $signer, publicKey: $publicKey}";
  }
}

class TransactionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  TransactionDataSource({List<Transaction> transactions}) {
    dataGridRows = transactions
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell(
                  columnName: 'datetime', value: dataGridRow.dateTimeStr),
              DataGridCell(columnName: 'temp', value: dataGridRow.temperature),
              DataGridCell(columnName: 'humidity', value: dataGridRow.humidity),
              DataGridCell(columnName: 'signer', value: dataGridRow.signer),
              DataGridCell(
                  columnName: 'public key', value: dataGridRow.publicKey),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Color(0xffebecf0),
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList());
  }
}
