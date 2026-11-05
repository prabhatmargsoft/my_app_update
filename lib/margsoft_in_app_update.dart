import 'package:flutter/services.dart';

class MargsoftInAppUpdate {
  static const MethodChannel _channel = MethodChannel('margsoft_in_app_update');

  static Future<String?> getPlatformVersion() async {
    return await _channel.invokeMethod<String>('getPlatformVersion');
  }

  static Future<Map<String, dynamic>> checkForUpdate() async {
    final result = await _channel.invokeMethod<Map>('checkForUpdate');

    return Map<String, dynamic>.from(result ?? {});
  }
}
