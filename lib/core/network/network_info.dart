import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //! Device is Connected to internet.
        print('Device is Connected.');

        return true;
      }
    } on SocketException catch (_) {
      //! Device is offline
      print('Device is offline.');

      return false;
    }
    return false;
  }
}
