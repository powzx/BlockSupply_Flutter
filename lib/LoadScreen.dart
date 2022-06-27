import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class LoadScreen extends StatefulWidget {
  final MqttServerClient client;
  final String uuid;

  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  LoadScreen({Key key, this.client, this.uuid}) : super(key: key);

  @override
  _LoadScreenState createState() =>
      _LoadScreenState(client: client, uuid: uuid);
}

class _LoadScreenState extends State<LoadScreen> {
  final MqttServerClient client;
  final String uuid;

  final _writeController = TextEditingController();

  _LoadScreenState({this.client, this.uuid});

  List<BluetoothService> _services = [];
  BluetoothDevice _connectedDevice;

  @override
  void initState() {
    super.initState();

    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceToList(device);
      }
    });

    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceToList(result.device);
      }
    });

    widget.flutterBlue.startScan();
  }

  void dispose() {
    super.dispose();
    widget.flutterBlue.stopScan();
  }

  _addDeviceToList(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      if (mounted) {
        setState(() {
          widget.devicesList.add(device);
        });
      }
    }
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = [];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(Container(
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
              children: <Widget>[
                Text(device.name == "" ? '(UNKNOWN DEVICE)' : device.name),
                Text(device.id.toString()),
              ],
            )),
            TextButton(
              child: Text(
                'Connect',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                widget.flutterBlue.stopScan();
                try {
                  await device.connect();
                } catch (exception) {
                  if (exception.code != 'already_connected') {
                    throw exception;
                  }
                } finally {
                  _services = await device.discoverServices();
                }

                setState(() {
                  _connectedDevice = device;
                });
              },
            ),
          ],
        ),
      ));
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = [];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = [];
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristic.value.listen((value) {
          print(value);
        });
        characteristicsWidget.add(Align(
          alignment: Alignment.centerLeft,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    characteristic.uuid.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  ..._buildReadWriteNotifyButton(characteristic),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Value: ' +
                      widget.readValues[characteristic.uuid].toString()),
                ],
              ),
              Divider(),
            ],
          ),
        ));
      }
      containers.add(Container(
        child: ExpansionTile(
          title: Text(service.uuid.toString()),
          children: characteristicsWidget,
        ),
      ));
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = [];

    if (characteristic.properties.read) {
      buttons.add(ButtonTheme(
        minWidth: 10,
        height: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            child: Text(
              'READ',
            ),
            onPressed: () async {
              var sub = characteristic.value.listen((value) {
                setState(() {
                  widget.readValues[characteristic.uuid] = value;
                });
              });
              await characteristic.read();
              sub.cancel();
            },
          ),
        ),
      ));
    }
    if (characteristic.properties.write) {
      buttons.add(ButtonTheme(
        minWidth: 10,
        height: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            child: Text(
              'WRITE',
            ),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Write"),
                      content: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _writeController,
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                            child: Text('Send')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')),
                      ],
                    );
                  });
            },
          ),
        ),
      ));
    }
    if (characteristic.properties.notify) {
      buttons.add(ButtonTheme(
        minWidth: 10,
        height: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            child: Text(
              'NOTIFY',
            ),
            onPressed: () async {
              characteristic.value.listen((value) {
                widget.readValues[characteristic.uuid] = value;
              });
              await characteristic.setNotifyValue(true);
            },
          ),
        ),
      ));
    }

    return buttons;
  }

  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
