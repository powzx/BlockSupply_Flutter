import 'package:local_auth/local_auth.dart';

class Authenticator {
  final LocalAuthentication _localAuthentication = new LocalAuthentication();

  Future<bool> authenticateWithFingerPrint() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: "Please authenticate to proceed",
      );
    } catch (err) {
      print(err);
    }
    return isAuthenticated;
  }
}