import 'package:librino/data/models/question/question.dart';

abstract class CreateLessonValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha o nome da lição';
    }
    return null;
  }

  static String? validateIndex(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Preencha a ordem da lição';
    }
    if (int.tryParse(value) == null) {
      return 'A ordem da lição deve ser um número inteiro';
    }
    return null;
  }

  static String? validateQuestions(List<Question>? questions) {
    if (questions == null || questions.isEmpty || questions.length < 3) {
      return 'Adicione no mínimo 3 questões para a lição';
    }
    return null;
  }
}
