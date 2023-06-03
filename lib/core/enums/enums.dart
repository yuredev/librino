import 'package:json_annotation/json_annotation.dart';

enum LessonStepType {
  @JsonValue(0)
  librasToWord,
  @JsonValue(1)
  librasToPhrase,
  @JsonValue(2)
  wordToLibras,
  @JsonValue(3)
  phraseToLibras,
  @JsonValue(4)
  supportContent,
}

enum GenderIdentity { man, woman, nonBinary, other }

enum ProfileType { instructor, studant }

enum AuditoryAbility { hearer, deaf }

enum SubscriptionStage { requested, approved, repproved }
