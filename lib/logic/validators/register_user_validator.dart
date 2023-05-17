import 'package:librino/core/enums/enums.dart';

abstract class RegisterUserValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o seu nome';
    }
    return null;
  }

  static String? validateSurname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o seu sobrenome';
    }
    return null;
  }

  static String? validateAuditoryAbility(AuditoryAbility? value) {
    if (value == null) {
      return 'Informe a condição auditiva';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Preencha o email';
    }
    final emailIsValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
    if (!emailIsValid) {
      return 'Formato de email inválido';
    }
    return null;
  }

  static String? validateGenderIdentity(GenderIdentity? genderIdentity) {
    return null;
  }

  static String? validateProfileType(ProfileType? profileType) {
    if (profileType == null) {
      return 'Informe o tipo do perfil';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preencha a senha';
    }
    if (value.length < 6) {
      return 'Sua senha deve possuir no mínimo 6 caracteres';
    }
    return null;
  }

  static String? validatePasswordConfirm(String? a, String? b) {
    if (a == null || a.isEmpty) {
      return null;
    }
    if (b == null || b.isEmpty) {
      'Confirme a senha';
    }
    if (a != b) {
      return 'As senhas não conferem';
    }
    return null;
  }
}
