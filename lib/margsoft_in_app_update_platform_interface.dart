import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'margsoft_in_app_update_method_channel.dart';

abstract class MargsoftInAppUpdatePlatform extends PlatformInterface {
  /// Constructs a MargsoftInAppUpdatePlatform.
  MargsoftInAppUpdatePlatform() : super(token: _token);

  static final Object _token = Object();

  static MargsoftInAppUpdatePlatform _instance =
      MethodChannelMargsoftInAppUpdate();

  /// The default instance of [MargsoftInAppUpdatePlatform] to use.
  ///
  /// Defaults to [MethodChannelMargsoftInAppUpdate].
  static MargsoftInAppUpdatePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MargsoftInAppUpdatePlatform] when
  /// they register themselves.
  static set instance(MargsoftInAppUpdatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
