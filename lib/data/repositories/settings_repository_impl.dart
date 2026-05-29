import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_settings.dart';

abstract class SettingsRepository {
  Future<UserSettings> getSettings();
  Future<void> updateSettings(UserSettings settings);
}

class SettingsRepositoryImpl implements SettingsRepository {
  static const _keyLimit = 'dailyLimit';
  static const _keyEyeCare = 'eyeCare';
  static const _keyMusic = 'bgMusic';
  static const _keyOffline = 'offline';
  static const _keyReminder = 'reminder';
  static const _keyReminderTime = 'reminderTime';

  @override
  Future<UserSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return UserSettings(
      dailyLimitMinutes: prefs.getInt(_keyLimit) ?? 30,
      eyeCareEnabled: prefs.getBool(_keyEyeCare) ?? true,
      bgMusicEnabled: prefs.getBool(_keyMusic) ?? true,
      offlineMode: prefs.getBool(_keyOffline) ?? false,
      reminderEnabled: prefs.getBool(_keyReminder) ?? false,
      reminderTime: prefs.getString(_keyReminderTime) ?? '19:00',
    );
  }

  @override
  Future<void> updateSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLimit, settings.dailyLimitMinutes);
    await prefs.setBool(_keyEyeCare, settings.eyeCareEnabled);
    await prefs.setBool(_keyMusic, settings.bgMusicEnabled);
    await prefs.setBool(_keyOffline, settings.offlineMode);
    await prefs.setBool(_keyReminder, settings.reminderEnabled);
    await prefs.setString(_keyReminderTime, settings.reminderTime);
  }
}
