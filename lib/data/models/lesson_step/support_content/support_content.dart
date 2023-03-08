import 'package:json_annotation/json_annotation.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/lesson_step/abstract_lesson_step/lesson_step.dart';

part 'support_content.g.dart';

@JsonSerializable()
class SupportContent extends LessonStep {
  final String content;

  const SupportContent({
    required this.content,
    required super.type,
    required super.id,
    required super.number,
  });

  factory SupportContent.fromJson(Map<String, dynamic> json) =>
      _$SupportContentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SupportContentToJson(this);

  @override
  List<Object?> get props => [...super.props, content];
}
