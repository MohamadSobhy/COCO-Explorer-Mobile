import 'dart:io';

import 'package:flutter/services.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      }
    } on PlatformException catch (_) {
      return false;
    }

    return false;
  }
}
