import 'package:equatable/equatable.dart';
import 'package:librino/core/enums/enums.dart';

class LibrinoUser extends Equatable {
  final AuditoryAbility auditoryAbility;
  final GenderIdentity? genderIdentity;
  final ProfileType profileType;
  final String name;
  final String surname;
  final String id;
  final String email;
  final String? photoURL;

  const LibrinoUser({
    required this.auditoryAbility,
    this.genderIdentity,
    required this.profileType,
    required this.name,
    required this.surname,
    required this.id,
    required this.email,
    this.photoURL,
  });

  @override
  List<Object?> get props => [
        auditoryAbility,
        genderIdentity,
        name,
        id,
        email,
        photoURL,
        profileType,
      ];
}
