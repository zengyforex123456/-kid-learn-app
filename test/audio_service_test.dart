import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/core/services/audio_service.dart';
import 'package:kid_learn_app/core/services/resource_service.dart';

void main() {
  group('AudioService (R7)', () {
    testWidgets('is a singleton', (tester) async {
      final a = AudioService();
      final b = AudioService();
      expect(identical(a, b), true);
    });
  });

  group('ResourceService (R10)', () {
    test('is a singleton', () {
      final a = ResourceService();
      final b = ResourceService();
      expect(identical(a, b), true);
    });

    testWidgets('methods return proper types', (tester) async {
      final svc = ResourceService();
      final downloaded = await svc.areResourcesDownloaded();
      expect(downloaded, isA<bool>());
      final version = await svc.getResourceVersion();
      expect(version, isA<int>());
    });
  });
}
