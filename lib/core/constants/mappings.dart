import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/routes.dart';

const lessonTypeToScreenNameMap = {
  LessonStepType.librasToWord: Routes.librasToWordQuestion,
  LessonStepType.librasToPhrase: Routes.librasToPhraseQuestion,
  LessonStepType.wordToLibras: Routes.wordToLibrasQuestion,
  LessonStepType.phraseToLibras: Routes.phraseToLibrasQuestion,
  LessonStepType.supportContent: Routes.supportContent,
};

const genderIdentityToString = {
  GenderIdentity.man: 'Homem',
  GenderIdentity.woman: 'Mulher',
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