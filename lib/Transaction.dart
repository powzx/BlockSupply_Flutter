import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Transaction {
  String secondsSinceEpoch;
  String dateTime;
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

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(secondsSinceEpoch) * 1000);

    DateFormat f = new DateFormat('yyyy-MM-dd hh:mm');
    this.dateTime = f.format(dateTime);
  }
}

class TransactionDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  TransactionDataSource({List<Transaction> transactions}) {
    dataGridRows = transactions
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell(columnName: 'datetime', value: dataGridRow.dateTime),
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
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          dataGridCell.value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList());
  }
}
