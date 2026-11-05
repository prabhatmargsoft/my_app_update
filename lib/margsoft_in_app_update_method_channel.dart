import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'margsoft_in_app_update_platform_interface.dart';

/// An implementation of [MargsoftInAppUpdatePlatform] that uses method channels.
class MethodChannelMargsoftInAppUpdate extends MargsoftInAppUpdatePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('margsoft_in_app_update');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
