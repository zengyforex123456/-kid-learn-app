class UserSettings {
  final int dailyLimitMinutes;
  final bool eyeCareEnabled;
  final bool bgMusicEnabled;
  final bool offlineMode;
  final bool reminderEnabled;
  final String reminderTime;

  const UserSettings({
    this.dailyLimitMinutes = 30,
    this.eyeCareEnabled = true,
    this.bgMusicEnabled = true,
    this.offlineMode = false,
    this.reminderEnabled = false,
    this.reminderTime = '19:00',
  });

  UserSettings copyWith({
    int? dailyLimitMinutes,
    bool? eyeCareEnabled,
    bool? bgMusicEnabled,
    bool? offlineMode,
    bool? reminderEnabled,
    String? reminderTime,
  }) =>
      UserSettings(
        dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
        eyeCareEnabled: eyeCareEnabled ?? this.eyeCareEnabled,
        bgMusicEnabled: bgMusicEnabled ?? this.bgMusicEnabled,
        offlineMode: offlineMode ?? this.offlineMode,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        reminderTime: reminderTime ?? this.reminderTime,
      );
}
