// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:librino/core/enums/enums.dart';

part 'firestore_user.g.dart';

@JsonSerializable()
class FirestoreUser {
  final String id;
  final AuditoryAbility auditoryAbility;
  final List<int> roles;
  final GenderIdentity? genderIdentity;
  final String surname;

  FirestoreUser({
    this.genderIdentity,
    required this.id,
    required this.auditoryAbility,
    required this.roles,
    required this.surname,
  });

  factory FirestoreUser.fromJson(Map<String, dynamic> json) =>
      _$FirestoreUserFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreUserToJson(this);

  FirestoreUser copyWith({
    String? id,
    AuditoryAbility? auditoryAbility,
    List<int>? roles,
    GenderIdentity? genderIdentity,
    String? surname,
  }) {
    return FirestoreUser(
      id: id ?? this.id,
      auditoryAbility: auditoryAbility ?? this.auditoryAbility,
      roles: roles ?? this.roles,
      genderIdentity: genderIdentity ?? this.genderIdentity,
      surname: surname ?? this.surname,
    );
  }
}
