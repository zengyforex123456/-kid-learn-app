import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/vocabulary_data.dart';
import '../../core/services/notification_service.dart';
import '../../domain/entities/vocabulary_item.dart';
import '../../domain/entities/user_settings.dart';
import '../../data/repositories/settings_repository_impl.dart';

final learnedCountProvider = StateProvider<int>((ref) => 0);
final englishLearnedCountProvider = StateProvider<int>((ref) => 0);
final playCountProvider = StateProvider<int>((ref) => 37);
final totalStarsProvider = StateProvider<int>((ref) => 24);
final selectedTabProvider = StateProvider<int>((ref) => 0);

final stickerListProvider = Provider<List<StickerState>>((ref) {
  return stickerData.map((s) => StickerState(id: s['id']!, name: s['name']!, emoji: s['emoji']!, isUnlocked: false, unlockGame: s['unlock'])).toList();
});

final unlockedStickersProvider = StateProvider<Set<String>>((ref) => {'s1', 's2', 's3'});

final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>((ref) => SettingsNotifier());

class SettingsNotifier extends StateNotifier<UserSettings> {
  final _repo = SettingsRepositoryImpl();

  SettingsNotifier() : super(const UserSettings()) {
    _load();
  }

  Future<void> _load() async {
    state = await _repo.getSettings();
  }

  Future<void> update(UserSettings settings) async {
    state = settings;
    await _repo.updateSettings(settings);
    await NotificationService().updateReminder(settings);
  }
}

final vocabularyProvider = Provider<List<VocabularyItem>>((ref) => vocabularyData);
final learnedWordsProvider = Provider<Set<int>>((ref) => {1, 2, 5, 6, 13, 15, 16, 26, 30, 38});

final eyeCareProvider = StateNotifierProvider<EyeCareNotifier, EyeCareState>((ref) => EyeCareNotifier());

class EyeCareState {
  final bool showRest;
  final DateTime? lastActiveTime;

  const EyeCareState({this.showRest = false, this.lastActiveTime});

  EyeCareState copyWith({bool? showRest, DateTime? lastActiveTime}) =>
      EyeCareState(showRest: showRest ?? this.showRest, lastActiveTime: lastActiveTime ?? this.lastActiveTime);
}

class EyeCareNotifier extends StateNotifier<EyeCareState> {
  EyeCareNotifier() : super(const EyeCareState());

  void checkRest(DateTime now) {
    if (state.lastActiveTime != null && now.difference(state.lastActiveTime!).inMinutes >= 15) {
      state = state.copyWith(showRest: true);
    }
  }

  void finishRest() {
    state = EyeCareState(lastActiveTime: DateTime.now(), showRest: false);
  }

  void startSession() {
    state = EyeCareState(lastActiveTime: DateTime.now(), showRest: false);
  }
}

class StickerState {
  final String id;
  final String name;
  final String emoji;
  final bool isUnlocked;
  final String? unlockGame;

  const StickerState({required this.id, required this.name, required this.emoji, this.isUnlocked = false, this.unlockGame});
}
