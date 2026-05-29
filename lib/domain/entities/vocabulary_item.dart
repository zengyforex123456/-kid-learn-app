enum WordCategory { fruit, animal, body, daily }

class VocabularyItem {
  final int id;
  final String chinese;
  final String english;
  final String emoji;
  final WordCategory category;
  final bool isLearned;

  const VocabularyItem({
    required this.id,
    required this.chinese,
    required this.english,
    required this.emoji,
    required this.category,
    this.isLearned = false,
  });

  VocabularyItem copyWith({bool? isLearned}) =>
      VocabularyItem(id: id, chinese: chinese, english: english, emoji: emoji, category: category, isLearned: isLearned ?? this.isLearned);

  Map<String, dynamic> toMap() => {'id': id, 'chinese': chinese, 'english': english, 'emoji': emoji, 'category': category.name, 'isLearned': isLearned ? 1 : 0};

  factory VocabularyItem.fromMap(Map<String, dynamic> map) => VocabularyItem(
        id: map['id'] as int,
        chinese: map['chinese'] as String,
        english: map['english'] as String,
        emoji: map['emoji'] as String,
        category: WordCategory.values.firstWhere((e) => e.name == map['category']),
        isLearned: (map['isLearned'] as int) == 1,
      );
}
