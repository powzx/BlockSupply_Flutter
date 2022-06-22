import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:blocksupply_flutter/Signer.dart';

/// An annotated simple subscribe/publish usage example for mqtt_server_client. Please read in with reference
/// to the MQTT specification. The example is runnable, also refer to test/mqtt_client_broker_test...dart
/// files for separate subscribe/publish tests.
/// First create a client, the client is constructed with a broker name, client identifier
/// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
/// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
/// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
/// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
/// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
/// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
/// of 1883 is used.
/// If you want to use websockets rather than TCP see below.
final client = MqttServerClient.withPort('192.168.11.109', 'Flutter App', 8883)
  ..onBadCertificate = (dynamic x509certificate) {
    return true;
  };

var pongCount = 0; // Pong counter

Future<int> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Signer signer = new Signer();

  print("Public key: ${signer.getPublicKey().toCompressedHex()}");
  print("Private key: ${signer.getPrivateKey()}");

  ByteData caData = await rootBundle.load('data/ca.crt');
  ByteData keyData = await rootBundle.load('data/client.key');
  ByteData certData = await rootBundle.load('data/client.crt');

  SecurityContext context = new SecurityContext()
    ..useCertificateChainBytes(certData.buffer.asUint8List())
    ..usePrivateKeyBytes(keyData.buffer.asUint8List())
    ..setClientAuthoritiesBytes(caData.buffer.asUint8List());

  client.secure = true;
  client.securityContext = context;
  client.logging(on: false);
  client.setProtocolV311();
  client.keepAlivePeriod = 20;
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;
  client.pongCallback = pong;

  final connMess = MqttConnectMessage()
      .withClientIdentifier('Mqtt_MyClientUniqueId')
      .withWillTopic('willtopic') // If you set this you must set a will message
      .withWillMessage('My Will message')
      .startClean() // Non persistent session for testing
      .withWillQos(MqttQos.atLeastOnce);
  print('EXAMPLE::Mosquitto client connecting....');
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    print('EXAMPLE::client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    print('EXAMPLE::socket exception - $e');
    client.disconnect();
  }

  /// Check we are connected
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    print('EXAMPLE::Mosquitto client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    print(
        'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    exit(-1);
  }

  String txnTopic = '/topic/${signer.getPublicKey().toCompressedHex()}/txnHash';
  String batchTopic = '/topic/${signer.getPublicKey().toCompressedHex()}/batchHash';
  client.subscribe(txnTopic, MqttQos.exactlyOnce);
  client.subscribe(batchTopic, MqttQos.exactlyOnce);

  /// The client has a change notifier object(see the Observable class) which we then listen to to get
  /// notifications of published updates to each subscribed topic.
  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    // final pt =
    //     MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print("Received hash: ${recMess.payload.message}");

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    // print(
    //     'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    // print('');
    String pubTopic = "";
    if (c[0].topic == '/topic/${signer.getPublicKey().toCompressedHex()}/txnHash') {
      pubTopic = '/topic/${signer.getPublicKey()
          .toCompressedHex()}/txnSig';
    } else if (c[0].topic == '/topic/${signer.getPublicKey().toCompressedHex()}/batchHash') {
      pubTopic = '/topic/${signer.getPublicKey()
          .toCompressedHex()}/batchSig';
    }

    final builder = MqttClientPayloadBuilder();

    String signature = signer.sign(recMess.payload.message);
    builder.addString(signature);
    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);
    print("Publishing signature: $signature");
  });

  /// If needed you can listen for published messages that have completed the publishing
  /// handshake which is Qos dependant. Any message received on this stream has completed its
  /// publishing handshake with the broker.
  client.published!.listen((MqttPublishMessage message) {
    print(
        'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
  });

  /// Lets publish to our topic
  /// Use the payload builder rather than a raw buffer
  /// Our known topic to publish to
  const pubTopic = '/topic/dispatch/init';
  final builder = MqttClientPayloadBuilder();
  builder.addString('{\"key\":\"${signer.getPublicKey().toCompressedHex()}\",\"publicKey\":\"${signer.getPublicKey().toCompressedHex()}\",\"data\":\"esp32 test\"}');

  /// Subscribe to it
  // print('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
  // client.subscribe(pubTopic, MqttQos.exactlyOnce);

  /// Publish it
  print('EXAMPLE::Publishing our topic');
  client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

  /// Ok, we will now sleep a while, in this gap you will see ping request/response
  /// messages being exchanged by the keep alive mechanism.
  // print('EXAMPLE::Sleeping....');
  // await MqttUtilities.asyncSleep(60);

  /// Finally, unsubscribe and exit gracefully
  // print('EXAMPLE::Unsubscribing');
  // client.unsubscribe(topic);

  /// Wait for the unsubscribe message from the broker if you wish.
  // await MqttUtilities.asyncSleep(2);
  // print('EXAMPLE::Disconnecting');
  // client.disconnect();
  // print('EXAMPLE::Exiting normally');
  return 0;
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('EXAMPLE::Subscription confirmed for topic $topic');
}

/// The unsolicited disconnect callback
void onDisconnected() {
  print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
  } else {
    print(
        'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
    exit(-1);
  }
  if (pongCount == 3) {
    print('EXAMPLE:: Pong count is correct');
  } else {
    print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
  }
}

/// The successful connect callback
void onConnected() {
  print(
      'EXAMPLE::OnConnected client callback - Client connection was successful');
}

/// Pong callback
void pong() {
  print('EXAMPLE::Ping response client callback invoked');
  pongCount++;
}
