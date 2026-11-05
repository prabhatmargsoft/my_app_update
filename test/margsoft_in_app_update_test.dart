import 'package:flutter_test/flutter_test.dart';
import 'package:margsoft_in_app_update/margsoft_in_app_update.dart';
import 'package:margsoft_in_app_update/margsoft_in_app_update_platform_interface.dart';
import 'package:margsoft_in_app_update/margsoft_in_app_update_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMargsoftInAppUpdatePlatform
    with MockPlatformInterfaceMixin
    implements MargsoftInAppUpdatePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MargsoftInAppUpdatePlatform initialPlatform =
      MargsoftInAppUpdatePlatform.instance;

  test('$MethodChannelMargsoftInAppUpdate is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMargsoftInAppUpdate>());
  });

  test('getPlatformVersion', () async {
    // MargsoftInAppUpdate margsoftInAppUpdatePlugin = MargsoftInAppUpdate();
    // final MargsoftInAppUpdatePlatform margsoftInAppUpdatePlugin =
    // MargsoftInAppUpdatePlatform();
    MockMargsoftInAppUpdatePlatform fakePlatform =
        MockMargsoftInAppUpdatePlatform();
    MargsoftInAppUpdatePlatform.instance = fakePlatform;

    expect(await MargsoftInAppUpdate.getPlatformVersion(), '42');
  });
}
