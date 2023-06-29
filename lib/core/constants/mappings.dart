import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/routes.dart';

const lessonTypeToScreenNameMap = {
  QuestionType.librasToWord: Routes.librasToWordQuestion,
  QuestionType.librasToPhrase: Routes.librasToPhraseQuestion,
  QuestionType.wordToLibras: Routes.wordToLibrasQuestion,
  QuestionType.phraseToLibras: Routes.phraseToLibrasQuestion,
};

const genderIdentityToString = {
  GenderIdentity.man: 'Masculino',
  GenderIdentity.woman: 'Feminino',
  GenderIdentity.nonBinary: 'Não binário',
  GenderIdentity.other: 'Outro',
};

const audityAbilityToString = {
  AuditoryAbility.deaf: 'Surdo',
  AuditoryAbility.hearer: 'Ouvinte',
};

const profileTypeToString = {
  ProfileType.instructor: 'Instrutor',
  ProfileType.studant: 'Estudante',
};

const questionTypeToString = {
  QuestionType.librasToPhrase: 'LIBRAS -> Portugûes escrito (Frase)',
  QuestionType.phraseToLibras: 'Portugûes escrito -> LIBRAS (Frase)',
  QuestionType.wordToLibras: 'Portugûes escrito -> LIBRAS (Palavra)',
  QuestionType.librasToWord: 'LIBRAS -> Portugûes escrito (Palavra)',
};
