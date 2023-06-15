// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:librino/core/enums/enums.dart';

part 'librino_user.g.dart';

@JsonSerializable()
class LibrinoUser extends Equatable {
  final AuditoryAbility auditoryAbility;
  final GenderIdentity? genderIdentity;
  final ProfileType profileType;
  final String name;
  final String surname;
  final String id;
  final String email;
  final String? photoURL;
  final List<String> completedLessonsIds;

  const LibrinoUser({
    required this.auditoryAbility,
    this.genderIdentity,
    required this.completedLessonsIds,
    required this.profileType,
    required this.name,
    required this.surname,
    required this.id,
    required this.email,
    this.photoURL,
  });

  bool get isInstructor => profileType == ProfileType.instructor;

  String get completeName => '$name $surname';

  @override
  List<Object?> get props => [
        auditoryAbility,
        genderIdentity,
        name,
        id,
        email,
        photoURL,
        profileType,
        completedLessonsIds,
      ];

  factory LibrinoUser.fromJson(Map<String, dynamic> json) =>
      _$LibrinoUserFromJson(json);

  Map<String, dynamic> toJson() => _$LibrinoUserToJson(this);

  LibrinoUser copyWith({
    AuditoryAbility? auditoryAbility,
    GenderIdentity? genderIdentity,
    ProfileType? profileType,
    String? name,
    String? surname,
    String? id,
    String? email,
    String? photoURL,
    List<String>? completedLessonsIds,
  }) {
    return LibrinoUser(
      auditoryAbility: auditoryAbility ?? this.auditoryAbility,
      genderIdentity: genderIdentity ?? this.genderIdentity,
      profileType: profileType ?? this.profileType,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      id: id ?? this.id,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      completedLessonsIds: completedLessonsIds ?? this.completedLessonsIds,
    );
  }
}
