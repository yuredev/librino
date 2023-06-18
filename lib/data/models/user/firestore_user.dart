// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:librino/core/enums/enums.dart';

part 'firestore_user.g.dart';

@JsonSerializable()
class FirestoreUser extends Equatable {
  final String id;
  final AuditoryAbility auditoryAbility;
  final List<int> roles;
  final GenderIdentity? genderIdentity;
  final String surname;
  final String name;
  final List<String>? completedLessonsIds;
  final String? email;
  final String? photoUrl;

  const FirestoreUser({
    this.genderIdentity,
    required this.id,
    required this.auditoryAbility,
    required this.roles,
    required this.surname,
    this.email,
    required this.name,
    this.photoUrl,
    this.completedLessonsIds,
  });

  String get completeName => '$name $surname';

  factory FirestoreUser.fromJson(Map<String, dynamic> json) =>
      _$FirestoreUserFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreUserToJson(this);

  @override
  List<Object?> get props => [
        genderIdentity,
        id,
        auditoryAbility,
        roles,
        surname,
        name,
        photoUrl,
        email,
      ];

  FirestoreUser copyWith({
    String? id,
    AuditoryAbility? auditoryAbility,
    List<int>? roles,
    GenderIdentity? genderIdentity,
    String? surname,
    String? name,
    List<String>? completedLessonsIds,
    String? email,
    String? photoUrl,
  }) {
    return FirestoreUser(
      id: id ?? this.id,
      auditoryAbility: auditoryAbility ?? this.auditoryAbility,
      roles: roles ?? this.roles,
      genderIdentity: genderIdentity ?? this.genderIdentity,
      surname: surname ?? this.surname,
      name: name ?? this.name,
      completedLessonsIds: completedLessonsIds ?? this.completedLessonsIds,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
