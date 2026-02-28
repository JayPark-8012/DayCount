import 'dart:convert';

class Milestone {
  final int? id;
  final int ddayId;
  final int days;
  final String label;
  final bool isCustom;
  final List<String> notifyBefore;

  const Milestone({
    this.id,
    required this.ddayId,
    required this.days,
    required this.label,
    this.isCustom = false,
    this.notifyBefore = const ['7d', '3d', '0d'],
  });

  factory Milestone.fromMap(Map<String, dynamic> map) {
    return Milestone(
      id: map['id'] as int?,
      ddayId: map['dday_id'] as int,
      days: map['days'] as int,
      label: map['label'] as String,
      isCustom: (map['is_custom'] as int? ?? 0) == 1,
      notifyBefore: _decodeNotifyBefore(map['notify_before']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'dday_id': ddayId,
      'days': days,
      'label': label,
      'is_custom': isCustom ? 1 : 0,
      'notify_before': jsonEncode(notifyBefore),
    };
  }

  Milestone copyWith({
    int? id,
    int? ddayId,
    int? days,
    String? label,
    bool? isCustom,
    List<String>? notifyBefore,
  }) {
    return Milestone(
      id: id ?? this.id,
      ddayId: ddayId ?? this.ddayId,
      days: days ?? this.days,
      label: label ?? this.label,
      isCustom: isCustom ?? this.isCustom,
      notifyBefore: notifyBefore ?? this.notifyBefore,
    );
  }

  static List<String> _decodeNotifyBefore(dynamic value) {
    if (value == null) return const ['7d', '3d', '0d'];
    if (value is String) {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        return decoded.cast<String>();
      }
    }
    return const ['7d', '3d', '0d'];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Milestone && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Milestone(id: $id, ddayId: $ddayId, days: $days, label: $label)';
}
