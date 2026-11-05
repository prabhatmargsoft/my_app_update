import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:margsoft_in_app_update/margsoft_in_app_update.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final String? version = await MargsoftInAppUpdate.getPlatformVersion();

    expect(version?.isNotEmpty, true);
  });
}
