import 'dart:async';
import 'package:blocksupply_flutter/signer.dart';
import 'package:blocksupply_flutter/login_state.dart';
import 'package:blocksupply_flutter/mqtt.dart';
import 'package:blocksupply_flutter/setup_state.dart';
import 'package:blocksupply_flutter/state_machine.dart';
import 'package:blocksupply_flutter/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await mqttConnect();
  await initSigner();

  // To remove secure data conveniently for debug purposes
  // Comment these two lines for actual workflow
  // StorageService _storageService = StorageService();
  // _storageService.deleteAllSecureData();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<States>(
          create: (context) {
            return stateStreamController.stream;
          },
          initialData: States.LOADING,
        ),
        StreamProvider<SetUpSubState>(
            create: (context) {
              return setupStreamController.stream;
            },
            initialData: SetUpSubState.WAITING),
        StreamProvider<LoginSubState>(
            create: (context) {
              return loginStreamController.stream;
            },
            initialData: LoginSubState.WAITING)
      ],
      child: MaterialApp(
        title: 'BlockSupply',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: StateMachine(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
