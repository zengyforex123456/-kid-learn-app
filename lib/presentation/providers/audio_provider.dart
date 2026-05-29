import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/audio_service.dart';

final audioServiceProvider = Provider<AudioService>((ref) => AudioService());

final audioInitializedProvider = FutureProvider<void>((ref) async {
  await ref.read(audioServiceProvider).init();
});
