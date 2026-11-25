import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

String _utc(DateTime value) => value.toUtc().toIso8601String();
String? _nullableUtc(DateTime? value) => value?.toUtc().toIso8601String();

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startedAt,
    this.thumbnail,
    this.endedAt,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String description;
  final String category;
  final String? thumbnail;
  @JsonKey(toJson: _utc)
  final DateTime startedAt;
  @JsonKey(toJson: _nullableUtc)
  final DateTime? endedAt;

  bool get isOngoing => endedAt == null;

  @JsonKey(includeToJson: false)
  final int starCount;
  @JsonKey(includeToJson: false)
  final bool isStarred;
  @JsonKey(includeToJson: false)
  final String starredByNames;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
