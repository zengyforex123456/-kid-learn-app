class Sticker {
  final String id;
  final String name;
  final String emoji;
  final bool isUnlocked;
  final String? unlockGame;

  const Sticker({
    required this.id,
    required this.name,
    required this.emoji,
    this.isUnlocked = false,
    this.unlockGame,
  });

  Sticker copyWith({bool? isUnlocked}) =>
      Sticker(id: id, name: name, emoji: emoji, isUnlocked: isUnlocked ?? this.isUnlocked, unlockGame: unlockGame);
}
