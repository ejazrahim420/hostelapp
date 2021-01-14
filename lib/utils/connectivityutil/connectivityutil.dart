import 'package:connectivity/connectivity.dart';

abstract class ConnectivityUtil {
  static Future<bool> checkConnectionIsAvailable() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
          // try {
          //   final result = await InternetAddress.lookup('google.com')
          //       .timeout(Duration(milliseconds: 1500));
          //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //     print(' Connection connectivityResult');
          //     return true;
          //   } else {
          //     print('No Connection connectivityResult');
          //     return false;
          //   }
          // } on SocketException catch (_) {
          //   return false;
          // }
          return true;

        default:
          return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
