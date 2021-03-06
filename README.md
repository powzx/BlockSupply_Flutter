## Introduction
This guide will bring you through the setting up and testing of the Flutter application for BlockSupply.

## Development Environment
Android Studio with Flutter SDK installed.

## Setting up and getting started
1. Fork the repository and clone into your computer.
2. Open a new terminal, and navigate to the BlockSupply_Flutter directory.
3. Open the project on an IDE.
4. Under the BlockSupply_Flutter directory, create a new folder "data".
5. Input your MQTT broker certificate authority, client certificate, and client private key as ca.crt, client.crt, and client.key respectively.
6. Open constants.dart, edit the identifier of the Flutter client and IP address of the MQTT broker by replacing `identifier` and `serverIp` respectively.
7. Connect a smartphone to your computer, and install the APK:
```
flutter install
```

## Testing
1. On the home page, enter the serial number that is set in the ESP32.
2. Observe the real-time update of the sensed data from the ESP32.