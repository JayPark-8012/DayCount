class DDay {
  final int? id;
  final String title;
  final String targetDate;
  final String category;
  final String emoji;
  final String themeId;
  final bool isCountUp;
  final bool isFavorite;
  final String? memo;
  final bool notifyEnabled;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;

  const DDay({
    this.id,
    required this.title,
    required this.targetDate,
    this.category = 'general',
    this.emoji = '📅',
    this.themeId = 'cloud',
    this.isCountUp = false,
    this.isFavorite = false,
    this.memo,
    this.notifyEnabled = true,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DDay.fromMap(Map<String, dynamic> map) {
    return DDay(
      id: map['id'] as int?,
      title: map['title'] as String,
      targetDate: map['target_date'] as String,
      category: map['category'] as String? ?? 'general',
      emoji: map['emoji'] as String? ?? '📅',
      themeId: map['theme_id'] as String? ?? 'cloud',
      isCountUp: (map['is_count_up'] as int? ?? 0) == 1,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      memo: map['memo'] as String?,
      notifyEnabled: (map['notify_enabled'] as int? ?? 1) == 1,
      sortOrder: map['sort_order'] as int? ?? 0,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'target_date': targetDate,
      'category': category,
      'emoji': emoji,
      'theme_id': themeId,
      'is_count_up': isCountUp ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
      'memo': memo,
      'notify_enabled': notifyEnabled ? 1 : 0,
      'sort_order': sortOrder,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  DDay copyWith({
    int? id,
    String? title,
    String? targetDate,
    String? category,
    String? emoji,
    String? themeId,
    bool? isCountUp,
    bool? isFavorite,
    String? memo,
    bool? notifyEnabled,
    int? sortOrder,
    String? createdAt,
    String? updatedAt,
  }) {
    return DDay(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDate: targetDate ?? this.targetDate,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      themeId: themeId ?? this.themeId,
      isCountUp: isCountUp ?? this.isCountUp,
      isFavorite: isFavorite ?? this.isFavorite,
      memo: memo ?? this.memo,
      notifyEnabled: notifyEnabled ?? this.notifyEnabled,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DDay && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DDay(id: $id, title: $title, targetDate: $targetDate)';
}
