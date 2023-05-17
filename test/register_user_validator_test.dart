import 'package:flutter_test/flutter_test.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/logic/validators/register_user_validator.dart';

void main() {
  group('Test the validators of the register user form', () {
    test('The name validator should work properly', () {
      expect(RegisterUserValidator.validateName(null), 'Preencha o seu nome');
      expect(RegisterUserValidator.validateName(''), 'Preencha o seu nome');
      expect(
          RegisterUserValidator.validateName('     '), 'Preencha o seu nome');
      expect(RegisterUserValidator.validateName('a'), null);
      expect(RegisterUserValidator.validateName('Yure'), null);
      expect(RegisterUserValidator.validateName('Yure Matias'), null);
      expect(RegisterUserValidator.validateName('   Y'), null);
      expect(RegisterUserValidator.validateName('83CçAS'), null);
    });
    test('The surname validator should work properly', () {
      expect(
        RegisterUserValidator.validateSurname(null),
        'Preencha o seu sobrenome',
      );
      expect(RegisterUserValidator.validateSurname(''),
          'Preencha o seu sobrenome');
      expect(
        RegisterUserValidator.validateSurname('     '),
        'Preencha o seu sobrenome',
      );
      expect(RegisterUserValidator.validateSurname('a'), null);
      expect(RegisterUserValidator.validateSurname('Yure Matias'), null);
      expect(RegisterUserValidator.validateSurname('   Y'), null);
    });
    test('The email validator should work properly', () {
      expect(RegisterUserValidator.validateEmail(null), 'Preencha o email');
      expect(RegisterUserValidator.validateEmail(''), 'Preencha o email');
      expect(
        RegisterUserValidator.validateEmail('     '),
        'Preencha o email',
      );
      expect(
        RegisterUserValidator.validateEmail('a'),
        'Formato de email inválido',
      );
      expect(
        RegisterUserValidator.validateEmail('Yure Matias'),
        'Formato de email inválido',
      );
      expect(
        RegisterUserValidator.validateEmail('   Y'),
        'Formato de email inválido',
      );
      expect(
        RegisterUserValidator.validateEmail('@gmail.com'),
        'Formato de email inválido',
      );
      expect(
        RegisterUserValidator.validateEmail('yurematias@'),
        'Formato de email inválido',
      );
      expect(
        RegisterUserValidator.validateEmail('yurematias@gmail.com'),
        null,
      );
      expect(
        RegisterUserValidator.validateEmail('yure.matias@gmail.com'),
        null,
      );
      expect(
        RegisterUserValidator.validateEmail('yurematias@ufrn.edu.com'),
        null,
      );
      expect(
        RegisterUserValidator.validateEmail('yurematias@outlook.com'),
        null,
      );
      expect(
        RegisterUserValidator.validateEmail('yure.matias.708@ufrn.edu.com'),
        null,
      );
    });
    test('The gender identity validator should work properly', () {
      expect(RegisterUserValidator.validateGenderIdentity(null), null);
      expect(
        RegisterUserValidator.validateGenderIdentity(GenderIdentity.man),
        null,
      );
      expect(
        RegisterUserValidator.validateGenderIdentity(GenderIdentity.woman),
        null,
      );
      expect(
        RegisterUserValidator.validateGenderIdentity(GenderIdentity.nonBinary),
        null,
      );
      expect(
        RegisterUserValidator.validateGenderIdentity(GenderIdentity.other),
        null,
      );
    });
    test('The autitory ability validator should work properly', () {
      expect(
        RegisterUserValidator.validateAuditoryAbility(null),
        'Informe a condição auditiva',
      );
      expect(
        RegisterUserValidator.validateAuditoryAbility(AuditoryAbility.deaf),
        null,
      );
      expect(
        RegisterUserValidator.validateAuditoryAbility(AuditoryAbility.hearer),
        null,
      );
    });
    test('The profile type validator should work properly', () {
      expect(
        RegisterUserValidator.validateProfileType(null),
        'Informe o tipo do perfil',
      );
      expect(
        RegisterUserValidator.validateProfileType(ProfileType.instructor),
        null,
      );
      expect(
        RegisterUserValidator.validateProfileType(ProfileType.studant),
        null,
      );
    });
    test('The password validator should work properly', () {
      expect(
        RegisterUserValidator.validatePassword(null),
        'Preencha a senha',
      );
      expect(RegisterUserValidator.validatePassword(''), 'Preencha a senha');
      expect(
        RegisterUserValidator.validatePassword('      '),
        null,
      );
      expect(
        RegisterUserValidator.validatePassword('a'),
        'Sua senha deve possuir no mínimo 6 caracteres',
      );
      expect(
        RegisterUserValidator.validatePassword('ac'),
        'Sua senha deve possuir no mínimo 6 caracteres',
      );
      expect(RegisterUserValidator.validatePassword('acde'),
          'Sua senha deve possuir no mínimo 6 caracteres');
      expect(
        RegisterUserValidator.validatePassword('acdef'),
        'Sua senha deve possuir no mínimo 6 caracteres',
      );
      expect(RegisterUserValidator.validatePassword('acdefg'), null);
      expect(
        RegisterUserValidator.validatePassword('Yure '),
        'Sua senha deve possuir no mínimo 6 caracteres',
      );
      expect(RegisterUserValidator.validatePassword('Yure  '), null);
      expect(RegisterUserValidator.validatePassword('    Y '), null);
      expect(RegisterUserValidator.validatePassword('     Y'), null);
    });
    test('The password confirm validator should work properly', () {
      expect(
        RegisterUserValidator.validatePasswordConfirm(null, null),
        null,
      );
      expect(RegisterUserValidator.validatePasswordConfirm('', null), null);
      expect(
        RegisterUserValidator.validatePasswordConfirm('     ', null),
        'As senhas não conferem',
      );
      expect(
        RegisterUserValidator.validatePasswordConfirm('a', ''),
        'As senhas não conferem',
      );
      expect(
        RegisterUserValidator.validatePasswordConfirm('ac', 'ac'),
        null,
      );
      expect(
        RegisterUserValidator.validatePasswordConfirm('acde', 'acde'),
        null,
      );
      expect(
        RegisterUserValidator.validatePasswordConfirm('acdef', 'abdef'),
        'As senhas não conferem',
      );
      expect(
        RegisterUserValidator.validatePasswordConfirm('acdefg ', 'acdefg'),
        'As senhas não conferem',
      );
      expect(
        RegisterUserValidator.validatePasswordConfirm('acdefg', ' acdefg'),
        'As senhas não conferem',
      );
      expect(
        RegisterUserValidator.validatePasswordConfirm('acdefg ', ' acdefg'),
        'As senhas não conferem',
      );
    });
  });
}
