import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class JoinScreen extends StatefulWidget {
  final MqttServerClient client;
  final String uuid;

  JoinScreen({Key key, this.client, this.uuid}) : super(key: key);

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> with SingleTickerProviderStateMixin {
  final MqttServerClient client;
  final String uuid;

  _JoinScreenState({this.client, this.uuid});

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: TabBar(
          controller: _tabController,
          indicatorColor: Colors.grey,
          labelColor: Colors.grey,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
          tabs: <Widget>[
            Tab(
              text: "Login",
            ),
            Tab(
              text: "Register",
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          LoginScreen(),
          RegisterScreen(),
        ],
      ),
    );
  }
}
